# Approach Documentation

## Infrastructure

I created the Azure infrastructure using Terraform.

The main resources include:

- Resource Group
- Virtual Network
- Public and private subnets
- Network Security Groups
- Linux Virtual Machine
- Azure Load Balancer
- PostgreSQL Flexible Server
- Azure Container Registry

I kept the architecture simple and focused first on making the complete deployment flow work.

## Terraform State

Terraform state is stored remotely in an Azure Storage Account.

The backend resources are created separately so that the Terraform state storage is independent from the main application infrastructure.

## Application

I created a simple Python Flask application with:

- Main application endpoint
- Health endpoint
- Unit tests

The application is packaged as a Docker image.

## CI/CD

GitHub Actions is used for CI/CD.

The pipeline:

1. Checks out the source code
2. Installs dependencies
3. Runs unit tests
4. Builds the Docker image
5. Authenticates to Azure using OIDC
6. Pushes the image to Azure Container Registry
7. Deploys the application to staging
8. Runs a health check
9. Waits for manual production approval
10. Deploys to production

## Security

GitHub Actions uses OIDC instead of storing Azure credentials.

The VM uses Managed Identity with AcrPull permission to download images from Azure Container Registry.

Network Security Groups are used to control traffic.

The VM does not have a public IP and application traffic enters through the Azure Load Balancer.

## Monitoring

Azure Monitor Agent and Log Analytics are used to monitor:

- CPU
- Memory
- Disk usage
- Linux Syslog

Application Insights is used for:

- Requests
- Failed requests
- Application latency

Two Grafana dashboards were created for infrastructure and application monitoring.

## Backup Strategy

Azure PostgreSQL Flexible Server is configured with 7 days of automated backup retention.

## Final Approach

My approach was to first complete the happy path:

Infrastructure → Application → Docker → CI/CD → Monitoring

After confirming the end-to-end flow, I added security, monitoring, backup and documentation improvements.