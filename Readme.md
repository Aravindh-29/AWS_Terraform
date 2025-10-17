Of course mava 🙌✨
Below is a **clean and professional `README.md`** that explains:

* What this Terraform code does 🏗️
* The architecture & security group rules 🔐
* AWS CLI & kubectl setup 🧰
* EKS cluster access commands 💻
* Best practices 🚀

This will be perfect to keep in your repo so that anyone can **understand, deploy, and use** the infra — even beginners 👶.

---

## 🐳 **EKS Infrastructure with Terraform**

### 📌 Overview

This Terraform project provisions a **secure, production-ready Amazon EKS cluster** with the following components:

* 🌐 **VPC** with public & private subnets
* 🐳 **EKS Cluster** (private endpoint)
* 👷 **EKS Node Group** in private subnets
* 💻 **EC2 Bastion Host** (to access EKS securely)
* 📦 **ECR Repository** (for storing container images)
* 🔐 **Security Groups** with least privilege
* 🌉 **NAT Gateway + Internet Gateway**
* ✅ **DNS support** enabled on the VPC

---

## 🏗️ **Architecture**

```
                      ┌─────────────────────────────┐
                      │   EKS Control Plane (Private)│
                      │   SG: Cluster SG             │
                      └──────────▲───────────────────┘
                                 │ 443 (HTTPS)
                                 │
                    ┌────────────┼─────────────┐
                    │                          │
           ┌────────▼────────┐         ┌───────▼────────┐
           │ EC2 Bastion     │         │ Worker Nodes   │
           │ (Public Subnet) │         │ (Private Subnet)│
           └────────┬────────┘         └─────────────────┘
                    │
         Ingress: 22, 80, 443 (VPC CIDR), 10250 (VPC CIDR)
         Egress: All
                    │
            ┌───────▼─────────┐
            │ NAT Gateway     │
            └───────┬─────────┘
                    │
            ┌───────▼─────────┐
            │ Internet Gateway│
            └─────────────────┘
```

✅ **All worker nodes stay in private subnets**.
✅ **The cluster API is private**, so no public exposure.
✅ **EC2 Bastion** is your secure entry point to interact with EKS.
✅ **ECR Repository** is used to store Docker images for deployment.

---

## 🔐 **Security Group Rules**

| Port  | Protocol | Source                 | Purpose                     | Status                      |
| ----- | -------- | ---------------------- | --------------------------- | --------------------------- |
| 22    | TCP      | 0.0.0.0/0              | SSH access to EC2 Bastion   | ✅ (can restrict to your IP) |
| 80    | TCP      | 0.0.0.0/0              | HTTP for testing (optional) | ✅ Optional                  |
| 443   | TCP      | VPC CIDR (10.0.0.0/16) | Secure EKS API traffic      | ✅ Recommended               |
| 10250 | TCP      | VPC CIDR (10.0.0.0/16) | Kubelet communication       | ✅ Required                  |
| All   | All      | 0.0.0.0/0              | Outbound traffic from EC2   | ✅ Required                  |

👉 The **EKS control plane** also has an ingress rule to allow traffic from `VPC CIDR` on port `443`.
👉 Worker nodes communicate privately inside the VPC.

---

## 🧰 **Tools You Need**

Before running Terraform and accessing the cluster, install:

### 🟡 1. Install AWS CLI

```bash
sudo apt update
sudo apt install -y unzip curl

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# verify
aws --version
```

**Configure AWS credentials**:

```bash
aws configure
# Provide your Access Key, Secret, Region (ap-south-1), and output format (json)
```

---

### 🟠 2. Install `kubectl`

```bash
# 1. Get the latest stable version
KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

# 2. Download the binary
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

# 3. Make it executable
chmod +x kubectl

# 4. Move it to your PATH
sudo mv kubectl /usr/local/bin/

# 5. Verify the installation
kubectl version --client

```

👉 This installs a version compatible with your EKS cluster.

---

### 🟢 3. Install Terraform

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

terraform -version
```

---

## 🚀 **How to Deploy the Infrastructure**

```bash
# 1. Initialize Terraform
terraform init

# 2. See what will be created
terraform plan

# 3. Apply changes
terraform apply
# Type "yes" when prompted
```

Once the resources are created, you’ll have:

✅ VPC + Subnets
✅ Internet Gateway & NAT Gateway
✅ EC2 Bastion (public)
✅ EKS Cluster (private endpoint)
✅ Worker Nodes
✅ ECR Repo

---

## 🔐 **Accessing EKS Cluster from EC2**

1. **SSH into the EC2 Bastion:**

```bash
ssh -i your-key.pem ec2-user@<ec2-public-ip>
```

2. **Update kubeconfig to connect to the EKS cluster:**

```bash
aws eks update-kubeconfig --region ap-south-1 --name demo-cluster
```

3. **Test the connection:**

```bash
kubectl get nodes
kubectl get svc
```

✅ If everything is configured properly, you will see the EKS worker nodes.

---

## 🐳 **Deploying Your Application (Optional)**

1. Build and push Docker image to ECR:

```bash
# Authenticate Docker to ECR
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com

# Tag and push
docker build -t demoapp .
docker tag demoapp:latest <AWS_ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/demo_ecr:latest
docker push <AWS_ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/demo_ecr:latest
```

2. Deploy Kubernetes manifest:

```bash
kubectl apply -f deployment.yaml
kubectl get pods
kubectl get svc
```

---

## 🛡️ **Security Best Practices**

* Restrict SSH port `22` to your own IP instead of `0.0.0.0/0`
* Always use private endpoint for EKS API (already configured ✅)
* Use least privilege IAM roles for nodes and cluster
* Don’t expose application services publicly unless needed
* Use HTTPS/Ingress controllers for real workloads

---

## 🧼 **Cleanup**

To delete everything created by Terraform:

```bash
terraform destroy
# Type "yes" to confirm
```

This will safely remove the VPC, EKS, EC2, ECR, and other resources.

---

## 🏁 Final Notes

* ✅ This setup follows AWS best practices for secure EKS
* 🛡️ EKS API is private and accessible only from EC2 bastion
* 🐳 Ready to deploy production-grade workloads
* 🚀 Fully automated with Terraform

---

✨ **Author:** Aravindh Kumar Naryana
📍 Region: `ap-south-1`
🧭 EKS Cluster: `demo-cluster`
☁️ AWS Services: VPC, EC2, EKS, ECR, NAT, IGW, Route Tables, SG

---

Would you like me to also **generate an architecture diagram image** (📊 PNG/PNG) based on this README so you can keep it in the repo as well? (It’ll look very professional 🔥)
