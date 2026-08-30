# Azure DevOps Assignment

This project demonstrates a simple end-to-end DevOps implementation on Microsoft Azure.

The main goal was to provision infrastructure using Terraform, containerize and deploy an application using CI/CD, and implement monitoring and centralized logging.

## Architecture

The application follows this flow:

```text
                         Internet
                            |
                            v
                   Azure Load Balancer
                            |
                            v
                    Linux Virtual Machine
                            |
                            v
                     Docker Container
                            |
                            v
                    Python Flask App


GitHub Actions ---> Azure Container Registry
                          |
                          v
                    Docker Images


Azure Monitor Agent ---> Log Analytics
                              |
                              +--> CPU / Memory / Disk
                              +--> Syslog

Flask Application ---> Application Insights
                              |
                              +--> Requests
                              +--> Errors
                              +--> Latency
```

The infrastructure includes:

- Azure Resource Group
- Virtual Network
- Public and private subnets
- Network Security Groups
- Linux Virtual Machine
- Azure Load Balancer
- PostgreSQL Flexible Server
- Azure Container Registry
- Log Analytics Workspace
- Azure Monitor Agent
- Application Insights

---

## Repository Structure

```text
azure-devops-assignment/
│
├── .github/
│   └── workflows/
│       └── cicd.yml
│
├── project-1-infrastructure/
│   ├── backend-setup/
│   └── terraform/
│
├── project-2-cicd/
│   └── app/
│       ├── app.py
│       ├── requirements.txt
│       ├── test_app.py
│       └── Dockerfile
│
├── APPROACH.md
├── CHALLENGES.md
└── README.md
```

---

# 1. Infrastructure Setup

Terraform is used to provision the Azure infrastructure.

## Prerequisites

The following tools are required:

- Terraform
- Azure CLI
- Git
- Docker
- Azure subscription

Login to Azure:

```bash
az login
```

### Terraform Backend

The Terraform state is stored remotely in an Azure Storage Account.

### Deploy Main Infrastructure

Go to:

```bash
cd ../terraform
```

Initialize Terraform:

```bash
terraform init
```

Format and validate:

```bash
terraform fmt
terraform validate
```

Review the deployment:

```bash
terraform plan
```

Deploy:

```bash
terraform apply
```

Terraform provisions the networking, VM, Load Balancer, PostgreSQL, ACR and monitoring resources.

---

# 2. Application

A simple Python Flask application is used for the deployment.

The application contains:

- Main application endpoint
- Health endpoint
- Basic unit tests

The application is packaged as a Docker image.

The Docker container exposes the Flask application on port `5000`.

In production, the Azure Load Balancer sends traffic to the VM, where Docker exposes the application through port `80`.

---

# 3. CI/CD

GitHub Actions is used for Continuous Integration and Continuous Deployment.

The pipeline follows this flow:

```text
Developer Push
      |
      v
Run Unit Tests
      |
      v
Build Docker Image
      |
      v
Push Image to ACR
      |
      v
Deploy to Staging
      |
      v
Health Check
      |
      v
Manual Production Approval
      |
      v
Deploy to Production
```

For pull requests, the pipeline runs application tests and validates the Docker build.

For changes pushed to the `main` branch, the Docker image is pushed to Azure Container Registry and deployed.

Production deployment requires manual approval through the GitHub production environment.

---

# 4. Terraform State Management

Terraform state is stored remotely using Azure Blob Storage.

The backend infrastructure is maintained separately from the main infrastructure.

This avoids keeping Terraform state only on a developer's local machine and allows the state to be managed centrally.

Azure Blob Storage also provides state locking during Terraform operations.

---

# 5. Security Considerations

The project includes several basic security practices.

### GitHub to Azure Authentication

GitHub Actions authenticates to Azure using OIDC federation.

This avoids storing a long-lived Azure client secret inside GitHub.

### Managed Identity

The Azure VM uses a system-assigned Managed Identity.

The identity has `AcrPull` permission so that the VM can download Docker images from Azure Container Registry without storing ACR credentials.

### RBAC

Azure RBAC is used to provide only the permissions required by GitHub Actions and the VM.

### Network Security

Network Security Groups are used to control traffic.

The application VM does not have a public IP address.

Application traffic enters through the Azure Load Balancer.

### Secrets

Sensitive values are not committed directly to the GitHub repository.

GitHub Actions secrets are used for sensitive CI/CD configuration.

For a production environment, Azure Key Vault would be preferred for centralized secret management.

### Production Improvements

For a production implementation I would additionally:

- Restrict SSH access to trusted IP addresses or use Azure Bastion
- Use private networking for PostgreSQL
- Use Azure Key Vault for application secrets
- Apply stricter RBAC permissions
- Add vulnerability scanning to the CI/CD pipeline

---

# 6. Backup Strategy

Azure PostgreSQL Flexible Server is configured with:

```text
7-day backup retention
```

This provides a basic database backup and recovery strategy.

For production environments, the backup retention period would be selected according to business recovery requirements.

---

# 7. Monitoring and Logging

Azure Monitor and Log Analytics are used for infrastructure monitoring.

The Azure Monitor Agent is installed on the Linux VM.

A Data Collection Rule collects:

- CPU utilization
- Memory usage
- Disk usage
- Linux Syslog

The data is sent to the Log Analytics Workspace.

Application Insights is integrated with the Flask application using Azure Monitor OpenTelemetry.

Application monitoring includes:

- Request count
- Failed requests
- Application latency

---

# 8. Dashboards

Two Azure Monitor Dashboards with Grafana were created.

## Infrastructure Dashboard

Displays:

- VM CPU utilization
- VM memory usage
- VM disk usage
- PostgreSQL CPU utilization

## Application Dashboard

Displays:

- Application request count
- Failed requests
- Average application latency

These dashboards provide a simple view of infrastructure and application health.

---

# 9. Cost Optimization

Since this is a demonstration environment, the infrastructure was kept simple.

Cost optimization measures include:

- Basic SKU Azure Container Registry
- Burstable PostgreSQL instance
- Single application VM
- Standard managed disk
- 30-day Log Analytics retention
- No unnecessary high-availability resources

Resources can be destroyed after testing to avoid unnecessary cloud charges:

```bash
terraform destroy
```

For production, resource sizing would be based on actual workload and monitoring data.

---

# 10. Challenges and Troubleshooting

Some of the main challenges encountered during the implementation were:

- Azure VM SKU availability
- Terraform PostgreSQL zone differences
- Terraform remote state configuration
- GitHub Actions OIDC authentication
- Azure Container Registry RBAC permissions
- Application Insights telemetry configuration
- Linux performance counter collection
- Syslog ingestion into Log Analytics

The detailed troubleshooting steps and resolutions are documented in:

```text
CHALLENGES.md
```

The overall implementation approach is documented in:

```text
APPROACH.md
```

---

# Summary

This project implements a complete DevOps flow using:

**Terraform → Azure Infrastructure → Docker → Azure Container Registry → GitHub Actions → Staging → Manual Production Approval → Production → Azure Monitor → Application Insights → Grafana Dashboards**

The implementation follows a simple happy-path approach while demonstrating infrastructure automation, CI/CD, security, monitoring, logging and backup concepts.
