# Azure DevOps Assignment

This project demonstrates a simple end-to-end DevOps implementation on Microsoft Azure.

The project covers:

- Infrastructure provisioning using Terraform
- Docker-based application deployment
- CI/CD using GitHub Actions
- Azure Container Registry for Docker images
- Monitoring using Azure Monitor and Application Insights
- Centralized logging using Log Analytics
- Infrastructure and application dashboards

## Architecture

The application follows this basic flow:

Internet
   |
Azure Load Balancer
   |
Linux Virtual Machine
   |
Docker Container
   |
Flask Application

The infrastructure also includes:

- Azure Virtual Network
- Public and private subnets
- Network Security Groups
- PostgreSQL Flexible Server
- Azure Container Registry
- Log Analytics Workspace
- Application Insights
- Azure Monitor Agent

## Infrastructure Setup

### Prerequisites

Install:

- Terraform
- Azure CLI
- Git
- Docker

Login to Azure:

```bash
az login