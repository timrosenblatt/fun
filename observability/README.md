# What is this?

Implementation of <https://sysdig.com/blog/golden-signals-kubernetes/>

Basically it creates a kind cluster, installs an ingress controller, Prometheus, Grafana, and an HTTP endpoint that generates random response times so that you get some metrics in the Grafana dashboards

# Usage

Uses taskfile

`task` to create the cluster + do the installs. `task clean` to teardown.

Make sure that the `hosts` file has the following entries pointing to 127.0.0.1
* app.local
* prometheus.local
* grafana.local 

Once the app is up, go to <http://app.local/sayhello/doug> or any of the other paths described in main.go

