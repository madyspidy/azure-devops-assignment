# Challenges and Resolutions

## 1. Terraform Remote State

### Challenge

Terraform initially used local state.

### Resolution

I created the Terraform backend separately using Azure Storage and then configured the main infrastructure to use the remote state.

---

## 2. Azure VM Size Availability

### Challenge

Some smaller VM sizes were unavailable in the selected Azure region.

### Resolution

I selected an available VM size and continued the deployment.

---

## 3. PostgreSQL Zone Difference

### Challenge

Azure automatically assigned a zone to PostgreSQL which caused Terraform to detect changes.

### Resolution

I used Terraform lifecycle configuration to ignore the automatically managed zone.

---

## 4. GitHub Actions OIDC Authentication

### Challenge

GitHub Actions initially failed to authenticate to Azure because the federated identity subject did not match.

### Resolution

I checked the authentication error and configured the correct GitHub repository subject in the Azure federated credential.

A separate federated credential was configured for the production environment.

---

## 5. Azure Container Registry Permissions

### Challenge

GitHub Actions and the VM required different ACR permissions.

### Resolution

GitHub Actions received AcrPush permission.

The VM Managed Identity received AcrPull permission.

---

## 6. Application Insights

### Challenge

The application was running but request telemetry did not initially appear in Application Insights.

### Resolution

I installed Azure Monitor OpenTelemetry and configured the Flask application using the Application Insights connection string.

---

## 7. VM Performance Metrics

### Challenge

Heartbeat was working but CPU, memory and disk data were initially missing.

### Resolution

I configured a Linux Data Collection Rule with the required performance counters.

---

## 8. Syslog Collection

### Challenge

Syslog was available locally on the VM but initially did not appear in Log Analytics.

### Resolution

I verified:

- Azure Monitor Agent
- rsyslog
- Data Collection Rule association
- AMA forwarding port
- DCR configuration
- AMA logs

After restarting Azure Monitor Agent and rsyslog, the logs appeared successfully.

## Troubleshooting Approach

Configuration → Connectivity → Permissions → Logs → Validation