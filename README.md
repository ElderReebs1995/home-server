# Home Server Infrastructure

A centralized, containerized home infrastructure deployment running natively on a Raspberry Pi 4 node. All core infrastructure components are managed declaratively via Docker Compose and tracked under version control.

## Running Services

### 1. Pi-hole (v6 Core)
* **Description:** Network-wide DNS sinkhole for ad-blocking and local mDNS host mapping.
* **Portsbound:** * `53/tcp & 53/udp` (DNS Resolution Engine)
  * `80/tcp` (Web UI Dashboard interface)

## Local Operations Deployment

To initialize or spin up state updates across the stack:

```bash
docker compose up -d