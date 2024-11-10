#!/bin/bash

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install

# Install Docker
sudo apt update
sudo apt install docker.io -y
sudo usermod -a -G docker jenkins
sudo usermod -a -G docker ubuntu
sudo systemctl restart docker
sudo chmod 777 /var/run/docker.sock

# Install Kubectl
sudo apt install curl -y
sudo curl -LO "https://dl.k8s.io/release/v1.28.4/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

# Install Java 17
# REF: https://www.rosehosting.com/blog/how-to-install-java-17-lts-on-ubuntu-20-04/
sudo apt install openjdk-17-jdk openjdk-17-jre -y
java -version

# Install Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install fontconfig openjdk-17-jre -y
sudo apt install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform -y

# Install SonarQube
docker run -d  --name sonar -p 9000:9000 sonarqube:lts-community

# Install Trivy
sudo apt install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt update
sudo apt install trivy -y

# Install Helm
sudo snap install helm --classic

# Install ArgoCD
# Ref: https://argo-cd.readthedocs.io/en/stable/cli_installation/
VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v$VERSION/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# Generate Jenkins initial login password
pass=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
echo "Jenkins Initial Password: $pass\n"