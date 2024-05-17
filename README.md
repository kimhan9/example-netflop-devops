# netflop-infra
Setup a Netflix Clone deployment to Kubernetes

![screenshot](pihqiNA_4.jpg)

# Jenkins Setup

1. Access Jenkins UI at http://<jenkins-ip>:8080
2. Go Manage Jenkins -> Plugins -> Available Plugins
3. Install following plugins
  - Eclipse Temurin Installer
  - SonarQube Scanner
  - NodeJs Plugin

## Configure Java and Nodejs in Global Tool Configuration

1. Go to Manage Jenkins -> Tools
2. Install **jdk17** (version 17) and **node18** (version 18). Click on **Apply** and then **Save**.

## Setup SonarQube

1. Go SonarQube web console at http://<jenkins-ip>:9000
2. Go Administration -> Security -> Users -> Tokens to generate token
2. Add the token in Jenkins. Manage Jenkins -> Credentials -> sonar-token
3. Go to Manage Jenkins -> System. Setup SonarQube Servers configuration.
4. Go to Manage Jenkins -> Tools. Setup SonarQube Scanner Installations configuration.
5. At SonarQube. Create New Project -> Manually.
6. At SonarQube project. Go Project Settings -> Webhook. Create Webhook with URL: http://jenkins_ip:8080/sonarqube_webhook/

## Install the Dependency-Check Plugin and Docker Tools in Jenkins

1. Go Jenkins Dashboard -> Manage Jenkins -> Plugins
2. Install following plugins:
  - OWASP Dependency-Check
  - Docker
  - Docker Commons
  - Docker Pipeline
  - Docker API
  - docker-build-step
3. Add Dockerhub access in Credentials.

## Configure Dependency-check and Docker Tool
1. Go to Dashboard -> Manage Jenkins -> Tools. Setup Dependency-Check Installation configuration. eg Name: DP-Check
2. Setup Docker configuration. eg Name: Docker

# Prometheus
1. Check the validity of the configuration file:
  `promtool check config /etc/prometheus/prometheus.yml`
2. Reload the Prometheus configuration without restarting:
  `curl -X POST http://localhost:9090/-/reload`
3. Access Prometheus target at http://<prometheus-ip>:9090/targets

# Grafana
1. Import Data Source -> Prometheus (http://localhost:9090)
2. Import Dashboard
  - Node exporter dashboard - 1860 
  - Jenkins dashboard - 9964 (require install Prometheus plugin in Jenkins)