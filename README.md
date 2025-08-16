# 🚀 Example Terraform EC2 Setup with Hardened Security & Docker

_A demo project showing Terraform provisioning, instance hardening, and Docker setup on AWS._

---

## 📖 Overview
While I’m newer to Terraform, this project applies my DevSecOps background to build **hardened**, **reproducible** infrastructure as a teaching artifact.

---

## 🗺️ Architecture at a Glance
```
Terraform --> AWS EC2 (Ubuntu)
                   |
                   +--> 🔐 SSH hardened
                   +--> 🛡️ nftables firewall
                   +--> 📦 Docker & Compose plugin
                   +--> 🖥️ Optional Portainer UI
```

---

## ✨ Key Features
- **Terraform-driven infrastructure**: EC2 instance, Security Group, and Key Pair.
- **🔐 Security-first mindset and configuration**:
    - Custom SSH port
    - Fail2Ban for brute-force protection
    - `nftables` firewall rules with least-privilege defaults
    - Automatic security updates
- **🐳 Docker-ready**: Installs Docker, Docker Compose plugin, and optional Portainer UI.
- **⚙️ Parameterized & reusable**: All sensitive settings are variables for easy demo → production transitions.

---

## 📋 Prerequisites
- AWS account with IAM user permissions to create EC2, Security Groups, and Key Pairs
- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed (v1.5+ recommended)
- SSH key pair ready

---

## 💡 Finding the latest Ubuntu AMI
Run this in AWS CLI (replace `us-east-1` with your region) to get the most recent Ubuntu 24.04 LTS AMI ID:

```bash
aws ec2 describe-images \
    --owners 099720109477 \
    --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*" \
        "Name=state,Values=available" \
    --query 'Images | sort_by(@, &CreationDate)[-1].ImageId' \
    --region us-east-1 --output text
```

Canonical’s AWS account ID is `099720109477` — this ensures you get the official image.

---

## ⚡ Quick Start — Demo Mode
_Opens ingress for fast testing; **not** production‑safe._

```bash
# 1. Clone and enter the project
git clone https://github.com/patrickbeane/example-terraform-ec2.git
cd example-terraform-ec2

# 2. Initialize Terraform
terraform init

# 3. Apply with all‑open demo settings
terraform apply \
    -var='allowed_cidr_blocks=["0.0.0.0/0"]' \
    -var='ami_id=ami-0abcdef1234567890' \
    -var='public_key_path=~/.ssh/YOUR_PUBLIC_KEY.pub'
```

After apply:  
- **SSH** -> `ssh -p <ssh_port> ubuntu@<instance_public_ip>`  
- **Portainer** -> `https://<instance_public_ip>:<portainer_port>` (accept cert warning)

---

## 🛡️ Full Setup — Production‑Ready
_Locks ingress to trusted CIDRs; HTTPS‑only by default._

```bash
# Copy example vars to a working file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars for your region, IPs, and key path
nano terraform.tfvars

# Then initialize and apply
terraform init
terraform apply
```

See [⚠️ Security Notes](#security-notes) before going live.

---

### Demo vs Production at a Glance

| Setting              | Demo Mode       | Production‑Ready           |
|----------------------|-----------------|----------------------------|
| `allowed_cidr_blocks`| `["0.0.0.0/0"]` | `["203.0.113.42/32"]`      |
| `enable_http`        | true            | false                      |
| Security Group       | wide open       | CIDR‑restricted            |
| nftables rules       | open ingress    | CIDR‑restricted ingress    |

---

## 🔍 Outputs

After applying, Terraform displays:

```
instance_public_ip = x.x.x.x
```

**Access your instance**:

```bash
ssh -p <ssh_port> ubuntu@<instance_public_ip>
```

**Access Portainer** (if enabled):

```bash
https://<instance_public_ip>:<portainer_port>
 ```

If you get a certificate warning on first visit, accept the self‑signed cert.

---

## ⚠️ Security Notes

- **Demo mode**: All ingress rules are `0.0.0.0/0` for testing and demonstration.
- **Production**: Restrict SSH/Portainer/HTTP/S ingress to trusted IPs or ranges.
- All key paths, ports, and AMIs are configurable via `variables.tf`.

---

## 📂 user-data Script Highlights
- OS updates & package upgrades
- SSH port change & password auth disabled
- Fail2Ban install & config
- `nftables` rules applied and persisted (demo vs production notes in script)
- Docker install, enabled, and user permissions set
- (Optional) pre‑pull of Portainer

---

## 🚧 Future Enhancements
- Optional TLS for Portainer via Traefik
- Pre‑baked AMIs with hardened baselines

 ---

## 📜 License
MIT License