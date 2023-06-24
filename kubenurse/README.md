

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
```

