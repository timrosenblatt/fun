
https://kubevela.io/docs/quick-start

# Setup

```
vela env init prod --namespace prod
vela up -f first-app.yaml
vela status first-vela-app
```



`vela port-forward first-vela-app 8000:8000`
This didn't work. I thought I had shut off the UI, but maybe I didn't. Switching to 8001:8000 fixed it.



So at this point I'm supposed to check the web app and then I can approve the app

`vela workflow resume first-vela-app`

And then I can see that it's in the prod namespace

`vela status first-vela-app`




# Teardown
`vela delete first-vela-app`
