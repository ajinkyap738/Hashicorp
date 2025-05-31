#!/bin/bash

set -euo pipefail

echo "Updating system packages..."
sudo yum update -y



echo "Installing Docker..."
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker

echo "Adding user '$USER' to docker group..."
sudo usermod -aG docker "$USER"

echo "Downloading kubectl stable version..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

echo "Downloading kubectl v1.33.0 (overwrite stable version)..."
curl -LO "https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl"

chmod +x kubectl
sudo mv kubectl /usr/local/bin/

TERRAFORM_VERSION="1.12.1"
echo "⬇️ Downloading Terraform $TERRAFORM_VERSION..."
curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

echo "🗂 Unzipping Terraform..."
unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip

echo "🚚 Moving Terraform binary to /usr/local/bin..."
sudo mv terraform /usr/local/bin/

echo "🧹 Cleaning up..."
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip LICENSE.txt

echo "✅ Terraform installation complete!"
terraform version

echo "Downloading and installing Helm v3.14.3..."
curl -LO https://get.helm.sh/helm-v3.14.3-linux-amd64.tar.gz
tar -zxvf helm-v3.14.3-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -rf linux-amd64 helm-v3.14.3-linux-amd64.tar.gz

echo "Downloading and installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

echo "Starting Minikube with Docker driver..."
minikube start --driver=docker

echo "Setup complete. You may need to logout/login for docker group changes to take effect."
