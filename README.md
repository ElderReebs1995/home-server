# Home Server Infrastructure

A centralized, containerized home infrastructure deployment running natively on a Raspberry Pi 4 node. All core infrastructure components are provisioned declaratively via **Terraform (IaC)** and tracked securely under version control.

## System Architecture & State Management
* **Orchestration:** Managed via the Terraform Docker Provider.
* **State File Tracking:** Decoupled structural layers localized inside individual workspaces to protect runtime lifecycle hooks.
* **Secrets Management:** Environment tokens, passphrases, and variables are completely externalized into a protected `.tfvars` backend to prevent credential leakage.

## Running Services

### 1. Pi-hole (v6 Core)
* **Description:** Network-wide DNS sinkhole for ad-blocking and local DNS resolution.
* **Network Mode:** `host` (Natively bound to physical hardware to preserve real-time client IP topology).
* **Automation:** Integrated with a post-deployment `local-exec` Python suite (`sync_blocklists.py`) for automated gravity database optimization.

### 2. Uptime Kuma
* **Description:** Self-hosted monitoring dashboard analyzing internal endpoint availability.
* **Persistence:** Stateful local storage volumes mapped directly under declarative state tracking.

---

## Deployment & Management

To plan or apply infrastructure adjustments from the root repository workspace:

```powershell
# Initialize providers and setup state backend
terraform init

# Audit configuration drift and verify structural plans
terraform plan

# Execute zero-downtime updates to the node
terraform apply
