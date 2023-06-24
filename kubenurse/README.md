# Notes
I feel a bit misled. The description said it monitors all network connections....I was trying to figure out how it could do taht.

> kubenurse is a little service that monitors all network connections in a Kubernetes cluster. Kubenurse measures request durations, records errors and exports those metrics in Prometheus format.

This does not mean "all the TCP connections taking place within the cluster", but it literally means the network connections _between the nodes_. If pods in the cluster are talking to each other, that is not reflected in kubenurse data...

I now realize the diagram under "health checks" is not a supplementary explanation, but that is actually the core functionality...each kubenurse pod is deployed as part of a daemonset, and it attempts to find all the others to say hi... this has the effect of checking network connectivity between nodes.


# Setup instructions

TODO need to change this to be a multinode cluster. The basic components are all running
but the more nodes, the more the data will be meaningful. 

?? I wonder what happens if I put a NetworkPolicy 

```
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s


```



```
helm repo add kubenurse https://postfinance.github.io/kubenurse/
helm install --create-namespace -n kubenurse kubenurse kubenurse/kubenurse --wait
```


next step is to set up prometheus and grafana so i can visualize everything
https://devopscube.com/setup-prometheus-monitoring-on-kubernetes/

then maybe i'll have to deploy a test app to generate some activity...

```
kubectl create namespace monitoring
kubectl create -f prom_cluster_role.yaml
kubectl create -f prom_configmap.yaml
kubectl create -f prom_deployment.yaml
kubectl create -f prom_service.yaml
kubectl create -f prom_ingress.yaml
```

be sure to add prometheus.local to /private/etc/hosts



Then...grafana time
https://devopscube.com/setup-grafana-kubernetes/

```
kubectl create -f grafana-datasource-config.yaml
kubectl create -f grafana-deployment.yaml
kubectl create -f grafana-service.yaml
kubectl create -f grafana-ingress.yaml
```

Be sure to add grafana.local to /private/etc/hosts
default creds are admin/admin


Open https://raw.githubusercontent.com/postfinance/kubenurse/master/doc/grafana-kubenurse.json and paste it into  http://grafana.local/dashboard/import 

TODO relaunch with clusters with more nodes