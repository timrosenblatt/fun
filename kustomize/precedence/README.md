run `kustomize build overlays/production` and notice the changes in the label on the deployment.

the commonLabels in the production/kustomization overrides all others
then the production/rename
then commonLabels from base/kustomization
then finally base/deployment goes through if nothing has overridden it

This makes sense, but how is it implemented?

In looking at the code, [the build command](https://github.com/kubernetes-sigs/kustomize/blob/cd7ba1744eadb793ab7cd056a76ee8a5ca725db9/kustomize/commands/build/build.go#L82) basically handles a lot of the CLI and "writing to disk" responsibilities, but the heavy lifting happens in the [Kustomizer's Run function](https://github.com/kubernetes-sigs/kustomize/blob/cd7ba1744eadb793ab7cd056a76ee8a5ca725db9/api/krusty/kustomizer.go#L55)

I think line 90 where `Run` does a `MakeCustomizedResMap`, although it should probably have been called `MakeKustomizedResMap`. Everything else in Run looks like it is just doing some setup for the main event, or teardown after the main event.

The [ResMap](https://github.com/kubernetes-sigs/kustomize/blob/cd7ba1744eadb793ab7cd056a76ee8a5ca725db9/api/resmap/resmap.go#L108) supports the core data structure which is a list of Resources. Based on the function names it looks like they do support the types of modifications that would be taking place during precendence operations.

?? What's the resmapFactory? that sounds like it could be involved in computing precedence

Going back to KustTarget and `makeCustomizedResMap`... 

I think AccumulateTarget is the most relevant function... I'm not looking for hashes, backreferences, resolving variables, and i don't know what ignorelocal is but that doesn't seem right either... also all of these come after the comment "The following steps must be done last"

`accumulateTarget` is starting to look really relevant. It does a couple of things:
* accumulateResources

* MakeTransformerConfig
* MergeConfig

* LoadConfigFromCRDs
* MergeConfig

* runGenerators
* accumulateComponents
* runTransformers
* runValidators

* MergeVars is called on the resource accumulator


Awesomely, <https://kubectl.docs.kubernetes.io/contributing/kustomize/howitworks/> seems to cover exactly how this happens.

So going back to the original idea...I'm looking at how overriding takes place among 2 dimensions...one is that overrides take precedence over the base, and the other is that commonLabels takes precedence over the patch or base resource.

I think the commonLabels dimension is most interesting, because the precedence of override-vs-base is just mostly intuitive...let's look for labels...

During `runTransformers` there are 2 kinds of transformers... builtin and external transformers. Among the builtin transformers there's helpfully a `LabelTransformer` 

Digging into `LabelTransformer`...

There is [code to configure the built-in transformers](https://github.com/kubernetes-sigs/kustomize/blob/c7d78970fb86782dbdded3a93944b774f826071f/api/internal/target/kusttarget_configplugin.go#L44)

! I'm curious to know a bit more about the transformers, but I think I have my answer. In `configureBuiltinTransformers` it sets up a bunch of transformers and then runs them in sequence. Naturally the transformation process is going to start with whatever's listed in the base resource, and then it's going to apply modifications on top of that...that's why the commonLabels overrides the label set in the patch... The transformation sequence is literally starting with the patches first, then the label transformer happens after that. 

Interestingly, the JSON6902 patch happens _after_ the label transformer, which suggests that the precedence relationship would flip there...

As a simple test...I'm going to add a JSON6902 patch that will override the app label again, but it will be in the in the same kustomization.yaml as the definition of the other patch. So essentially what should happen is that the Deployment will be loaded off disk by base, transformed by the kustomization in there, then it will get the production kustomization applying the patch, then the commonLabel, and then finally it will be overridden by the PatchJson6902Transformer....

...it worked. running `kustomize build overlays/production` now shows the deployment gets an app label "overridden-by-6902" which is expected.

to mess around later, `make && make kustomize` seems to be what's required to get a built binary in $GOBIN. `make nuke` will clean everything up.