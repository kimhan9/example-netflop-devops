# Setup Monitoring Server

## Prometheus
1. Check the validity of the configuration file:
  `promtool check config /etc/prometheus/prometheus.yml`
2. Reload the Prometheus configuration without restarting:
  `curl -X POST http://localhost:9090/-/reload`
3. Access Prometheus target at http://<prometheus-ip>:9090/targets

## Grafana
1. Import Data Source -> Prometheus (http://localhost:9090)
2. Import Dashboard
  - Node exporter dashboard - 1860 
  - Jenkins dashboard - 9964 (require install Prometheus plugin in Jenkins)