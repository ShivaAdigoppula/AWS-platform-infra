# Latest Amazon Linux 2023 image ID, published by AWS in SSM Parameter Store
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# ---------- Firewall ----------
resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Jenkins and SonarQube server"
  vpc_id      = var.vpc_id

  ingress {
    description = "Jenkins UI (you) + GitHub webhooks"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = concat(var.admin_cidrs, var.webhook_cidrs)
  }

  ingress {
    description = "SonarQube UI (you only)"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = var.admin_cidrs
  }

  egress {
    description = "Server may reach the internet (packages, GitHub, AWS APIs)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name}-sg" }
}

# ---------- The server ----------
resource "aws_instance" "this" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile   = var.instance_profile_name

  # Script that runs ONCE at first boot and installs everything
  user_data                   = file("${path.module}/user_data.sh")
  user_data_replace_on_change = true

  # Security: require IMDSv2 (protects the role credentials from SSRF attacks)
  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  tags = { Name = var.name }

  lifecycle {
    # AWS publishes a new AL2023 image regularly. Without this,
    # every new image would make Terraform REPLACE (destroy!) Jenkins.
    ignore_changes = [ami]
  }
}

# ---------- Fixed public IP ----------
# Survives stop/start, so the GitHub webhook URL never changes
resource "aws_eip" "this" {
  domain   = "vpc"
  instance = aws_instance.this.id
  tags     = { Name = "${var.name}-eip" }
}