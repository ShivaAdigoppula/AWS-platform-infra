#!/bin/bash
# Runs once at first boot as root. Log: /var/log/cloud-init-output.log
set -euxo pipefail

# --- Kernel settings SonarQube's built-in search engine requires ---
cat > /etc/sysctl.d/99-sonarqube.conf <<'EOF'
vm.max_map_count=524288
fs.file-max=131072
EOF
sysctl --system

# --- Base packages: git, Docker, Java (Jenkins needs Java) ---
dnf -y install git docker java-21-amazon-corretto-headless dnf-plugins-core
systemctl enable --now docker

# --- Jenkins (from the official Jenkins repository) ---
curl -fsSL -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
dnf -y install jenkins
usermod -aG docker jenkins          # let Jenkins use Docker
systemctl enable --now jenkins

# --- Terraform (from HashiCorp's repository) ---
dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
dnf -y install terraform

# --- kubectl ---
KVER=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
curl -fsSL -o /usr/local/bin/kubectl "https://dl.k8s.io/release/${KVER}/bin/linux/amd64/kubectl"
chmod +x /usr/local/bin/kubectl

# --- Trivy ---
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# --- SonarQube in Docker (data kept in Docker volumes) ---
docker run -d --name sonarqube --restart unless-stopped -p 9000:9000 \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  -v sonarqube_logs:/opt/sonarqube/logs \
  sonarqube:community

echo "BOOTSTRAP DONE"