#!/usr/bin/env bash
set -euo pipefail

# repair_tree.sh
# Build a target directory `cybersecurity-lab` to match the provided manifest.
# Usage: ./scripts/repair_tree.sh [--dry-run] [--execute]

TARGET=cybersecurity-lab
DRY_RUN=1

while [[ $# -gt 0 ]]; do
  case $1 in
    --execute) DRY_RUN=0; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) echo "Usage: $0 [--dry-run|--execute]"; exit 0 ;;
    *) echo "Unknown arg $1"; exit 2 ;;
  esac
done

mkdir -p "$TARGET"

manifest=$(cat <<'MAN'
cybersecurity-lab/README.md
cybersecurity-lab/LICENSE
cybersecurity-lab/.gitignore
cybersecurity-lab/ansible.cfg
cybersecurity-lab/requirements.yml

cybersecurity-lab/.github/workflows/validate-playbooks.yml
cybersecurity-lab/.github/workflows/backup-trigger.yml
cybersecurity-lab/.github/workflows/security-scan.yml

cybersecurity-lab/docs/00-quick-start.md
cybersecurity-lab/docs/01-architecture.md
cybersecurity-lab/docs/02-prerequisites.md
cybersecurity-lab/docs/03-installation.md
cybersecurity-lab/docs/04-daily-operations.md
cybersecurity-lab/docs/05-maintenance.md
cybersecurity-lab/docs/06-troubleshooting.md
cybersecurity-lab/docs/07-compliance.md
cybersecurity-lab/docs/08-disaster-recovery.md
cybersecurity-lab/docs/diagrams/network-topology.png
cybersecurity-lab/docs/diagrams/vlan-architecture.png
cybersecurity-lab/docs/diagrams/vm-layout.png
cybersecurity-lab/docs/diagrams/data-flow.png

cybersecurity-lab/inventory/hosts.yml
cybersecurity-lab/inventory/group_vars/all.yml
cybersecurity-lab/inventory/group_vars/proxmox.yml
cybersecurity-lab/inventory/group_vars/firewalls.yml
cybersecurity-lab/inventory/group_vars/blue_team.yml
cybersecurity-lab/inventory/group_vars/red_team.yml
cybersecurity-lab/inventory/group_vars/targets.yml
cybersecurity-lab/inventory/group_vars/malware_lab.yml
cybersecurity-lab/inventory/group_vars/forensics.yml
cybersecurity-lab/inventory/group_vars/research.yml
cybersecurity-lab/inventory/host_vars/proxmox-p520.yml
cybersecurity-lab/inventory/host_vars/opnsense-fw.yml
cybersecurity-lab/inventory/host_vars/security-onion.yml
cybersecurity-lab/inventory/host_vars/blackarch.yml
cybersecurity-lab/inventory/host_vars/rocky-corp.yml
cybersecurity-lab/inventory/host_vars/remnux.yml
cybersecurity-lab/inventory/host_vars/openbsd-ir.yml
cybersecurity-lab/inventory/host_vars/openbsd-vault.yml
cybersecurity-lab/inventory/host_vars/openbsd-net.yml

cybersecurity-lab/playbooks/00-site.yml

cybersecurity-lab/playbooks/01-bootstrap/bootstrap-proxmox.yml
cybersecurity-lab/playbooks/01-bootstrap/bootstrap-networking.yml
cybersecurity-lab/playbooks/01-bootstrap/bootstrap-storage.yml

cybersecurity-lab/playbooks/02-infrastructure/create-all-vms.yml
cybersecurity-lab/playbooks/02-infrastructure/create-vm-templates.yml
cybersecurity-lab/playbooks/02-infrastructure/configure-base-vms.yml
cybersecurity-lab/playbooks/02-infrastructure/configure-networking.yml

cybersecurity-lab/playbooks/03-applications/deploy-opnsense.yml
cybersecurity-lab/playbooks/03-applications/deploy-security-onion.yml
cybersecurity-lab/playbooks/03-applications/deploy-blackarch.yml
cybersecurity-lab/playbooks/03-applications/deploy-remnux.yml
cybersecurity-lab/playbooks/03-applications/deploy-forensics.yml
cybersecurity-lab/playbooks/03-applications/deploy-targets.yml

cybersecurity-lab/playbooks/04-security/harden-all.yml
cybersecurity-lab/playbooks/04-security/harden-proxmox.yml
cybersecurity-lab/playbooks/04-security/harden-linux.yml
cybersecurity-lab/playbooks/04-security/harden-openbsd.yml
cybersecurity-lab/playbooks/04-security/configure-firewall.yml
cybersecurity-lab/playbooks/04-security/configure-ids.yml

cybersecurity-lab/playbooks/05-monitoring/deploy-monitoring.yml
cybersecurity-lab/playbooks/05-monitoring/configure-siem.yml
cybersecurity-lab/playbooks/05-monitoring/configure-logging.yml
cybersecurity-lab/playbooks/05-monitoring/configure-alerts.yml

cybersecurity-lab/playbooks/06-backup/configure-backups.yml
cybersecurity-lab/playbooks/06-backup/backup-now.yml
cybersecurity-lab/playbooks/06-backup/test-restore.yml

cybersecurity-lab/playbooks/07-compliance/audit-all.yml
cybersecurity-lab/playbooks/07-compliance/audit-nist.yml
cybersecurity-lab/playbooks/07-compliance/audit-security.yml
cybersecurity-lab/playbooks/07-compliance/generate-reports.yml

cybersecurity-lab/playbooks/99-operations/update-all.yml
cybersecurity-lab/playbooks/99-operations/patch-security.yml
cybersecurity-lab/playbooks/99-operations/restart-services.yml
cybersecurity-lab/playbooks/99-operations/health-check.yml
cybersecurity-lab/playbooks/99-operations/snapshot-all.yml
cybersecurity-lab/playbooks/99-operations/restore-vm.yml
cybersecurity-lab/playbooks/99-operations/destroy-rebuild.yml

cybersecurity-lab/roles/common/tasks/main.yml
cybersecurity-lab/roles/common/tasks/packages.yml
cybersecurity-lab/roles/common/tasks/users.yml
cybersecurity-lab/roles/common/tasks/ssh.yml
cybersecurity-lab/roles/common/tasks/timezone.yml
cybersecurity-lab/roles/common/templates/sshd_config.j2
cybersecurity-lab/roles/common/templates/sudoers.j2
cybersecurity-lab/roles/common/handlers/main.yml
cybersecurity-lab/roles/common/defaults/main.yml

cybersecurity-lab/roles/proxmox/tasks/main.yml
cybersecurity-lab/roles/proxmox/tasks/repositories.yml
cybersecurity-lab/roles/proxmox/tasks/networking.yml
cybersecurity-lab/roles/proxmox/tasks/storage.yml
cybersecurity-lab/roles/proxmox/tasks/users.yml
cybersecurity-lab/roles/proxmox/tasks/backup.yml
cybersecurity-lab/roles/proxmox/tasks/hardening.yml
cybersecurity-lab/roles/proxmox/templates/interfaces.j2
cybersecurity-lab/roles/proxmox/templates/storage.cfg.j2
cybersecurity-lab/roles/proxmox/templates/datacenter.cfg.j2
cybersecurity-lab/roles/proxmox/files/zfs-tuning.conf
cybersecurity-lab/roles/proxmox/defaults/main.yml

cybersecurity-lab/roles/proxmox-vm/tasks/main.yml
cybersecurity-lab/roles/proxmox-vm/tasks/create-vm.yml
cybersecurity-lab/roles/proxmox-vm/tasks/configure-vm.yml
cybersecurity-lab/roles/proxmox-vm/tasks/cloud-init.yml
cybersecurity-lab/roles/proxmox-vm/tasks/start-vm.yml
cybersecurity-lab/roles/proxmox-vm/templates/vm-config.j2
cybersecurity-lab/roles/proxmox-vm/templates/cloud-init.j2
cybersecurity-lab/roles/proxmox-vm/defaults/main.yml

cybersecurity-lab/roles/opnsense/tasks/main.yml
cybersecurity-lab/roles/opnsense/tasks/initial-setup.yml
cybersecurity-lab/roles/opnsense/tasks/interfaces.yml
cybersecurity-lab/roles/opnsense/tasks/vlans.yml
cybersecurity-lab/roles/opnsense/tasks/firewall-rules.yml
cybersecurity-lab/roles/opnsense/tasks/nat.yml
cybersecurity-lab/roles/opnsense/tasks/dhcp.yml
cybersecurity-lab/roles/opnsense/tasks/dns.yml
cybersecurity-lab/roles/opnsense/tasks/ids-ips.yml
cybersecurity-lab/roles/opnsense/tasks/backup.yml
cybersecurity-lab/roles/opnsense/templates/config.xml.j2
cybersecurity-lab/roles/opnsense/templates/firewall-rules.xml.j2
cybersecurity-lab/roles/opnsense/templates/nat-rules.xml.j2
cybersecurity-lab/roles/opnsense/templates/dhcp-config.xml.j2
cybersecurity-lab/roles/opnsense/defaults/main.yml

cybersecurity-lab/roles/security-onion/tasks/main.yml
cybersecurity-lab/roles/security-onion/tasks/prerequisites.yml
cybersecurity-lab/roles/security-onion/tasks/download.yml
cybersecurity-lab/roles/security-onion/tasks/install.yml
cybersecurity-lab/roles/security-onion/tasks/configure.yml
cybersecurity-lab/roles/security-onion/tasks/suricata.yml
cybersecurity-lab/roles/security-onion/tasks/zeek.yml
cybersecurity-lab/roles/security-onion/tasks/elasticsearch.yml
cybersecurity-lab/roles/security-onion/tasks/kibana.yml
cybersecurity-lab/roles/security-onion/tasks/users.yml
cybersecurity-lab/roles/security-onion/templates/soup.conf.j2
cybersecurity-lab/roles/security-onion/templates/suricata.yaml.j2
cybersecurity-lab/roles/security-onion/templates/local.rules.j2
cybersecurity-lab/roles/security-onion/files/custom-rules/custom.rules
cybersecurity-lab/roles/security-onion/files/custom-rules/lab-specific.rules
cybersecurity-lab/roles/security-onion/files/dashboards/.gitkeep
cybersecurity-lab/roles/security-onion/defaults/main.yml

cybersecurity-lab/roles/blackarch/tasks/main.yml
cybersecurity-lab/roles/blackarch/tasks/base-system.yml
cybersecurity-lab/roles/blackarch/tasks/blackarch-repo.yml
cybersecurity-lab/roles/blackarch/tasks/tools.yml
cybersecurity-lab/roles/blackarch/tasks/custom-tools.yml
cybersecurity-lab/roles/blackarch/tasks/aliases.yml
cybersecurity-lab/roles/blackarch/tasks/vpn.yml
cybersecurity-lab/roles/blackarch/templates/bashrc.j2
cybersecurity-lab/roles/blackarch/templates/tool-configs/.gitkeep
cybersecurity-lab/roles/blackarch/files/custom-scripts/.gitkeep
cybersecurity-lab/roles/blackarch/files/wordlists/.gitkeep
cybersecurity-lab/roles/blackarch/vars/tools-list.yml

cybersecurity-lab/roles/remnux/tasks/main.yml
cybersecurity-lab/roles/remnux/tasks/remnux-install.yml
cybersecurity-lab/roles/remnux/tasks/tools.yml
cybersecurity-lab/roles/remnux/tasks/isolation.yml
cybersecurity-lab/roles/remnux/tasks/samples.yml
cybersecurity-lab/roles/remnux/tasks/documentation.yml
cybersecurity-lab/roles/remnux/templates/remnux-config.j2
cybersecurity-lab/roles/remnux/defaults/main.yml

cybersecurity-lab/roles/openbsd-base/tasks/main.yml
cybersecurity-lab/roles/openbsd-base/tasks/packages.yml
cybersecurity-lab/roles/openbsd-base/tasks/hardening.yml
cybersecurity-lab/roles/openbsd-base/tasks/pf.yml
cybersecurity-lab/roles/openbsd-base/tasks/users.yml
cybersecurity-lab/roles/openbsd-base/templates/pf.conf.j2
cybersecurity-lab/roles/openbsd-base/templates/sysctl.conf.j2
cybersecurity-lab/roles/openbsd-base/templates/rc.conf.local.j2
cybersecurity-lab/roles/openbsd-base/defaults/main.yml

cybersecurity-lab/roles/forensics/tasks/main.yml
cybersecurity-lab/roles/forensics/tasks/forensic-tools.yml
cybersecurity-lab/roles/forensics/tasks/case-management.yml
cybersecurity-lab/roles/forensics/tasks/evidence-handling.yml
cybersecurity-lab/roles/forensics/templates/case-template.j2
cybersecurity-lab/roles/forensics/files/scripts/.gitkeep

cybersecurity-lab/roles/rocky-target/tasks/main.yml
cybersecurity-lab/roles/rocky-target/tasks/web-server.yml
cybersecurity-lab/roles/rocky-target/tasks/database.yml
cybersecurity-lab/roles/rocky-target/tasks/ftp-server.yml
cybersecurity-lab/roles/rocky-target/tasks/smb-server.yml
cybersecurity-lab/roles/rocky-target/tasks/vulnerabilities.yml
cybersecurity-lab/roles/rocky-target/tasks/logging.yml
cybersecurity-lab/roles/rocky-target/templates/httpd.conf.j2
cybersecurity-lab/roles/rocky-target/templates/webapp/.gitkeep
cybersecurity-lab/roles/rocky-target/files/vulnerable-webapp/.gitkeep

cybersecurity-lab/roles/hardening/tasks/main.yml
cybersecurity-lab/roles/hardening/tasks/ssh.yml
cybersecurity-lab/roles/hardening/tasks/firewall.yml
cybersecurity-lab/roles/hardening/tasks/services.yml
cybersecurity-lab/roles/hardening/tasks/accounts.yml
cybersecurity-lab/roles/hardening/tasks/audit.yml
cybersecurity-lab/roles/hardening/tasks/selinux.yml
cybersecurity-lab/roles/hardening/tasks/updates.yml
cybersecurity-lab/roles/hardening/templates/sshd_config.j2
cybersecurity-lab/roles/hardening/templates/login.defs.j2
cybersecurity-lab/roles/hardening/templates/audit.rules.j2
cybersecurity-lab/roles/hardening/defaults/main.yml

cybersecurity-lab/roles/monitoring/tasks/main.yml
cybersecurity-lab/roles/monitoring/tasks/prometheus.yml
cybersecurity-lab/roles/monitoring/tasks/grafana-agent.yml
cybersecurity-lab/roles/monitoring/tasks/rsyslog.yml
cybersecurity-lab/roles/monitoring/tasks/health-checks.yml
cybersecurity-lab/roles/monitoring/templates/prometheus.yml.j2
cybersecurity-lab/roles/monitoring/templates/rsyslog.conf.j2
cybersecurity-lab/roles/monitoring/files/scripts/.gitkeep

cybersecurity-lab/roles/backup/tasks/main.yml
cybersecurity-lab/roles/backup/tasks/configure-jobs.yml
cybersecurity-lab/roles/backup/tasks/zfs-snapshots.yml
cybersecurity-lab/roles/backup/tasks/config-backup.yml
cybersecurity-lab/roles/backup/tasks/offsite-backup.yml
cybersecurity-lab/roles/backup/templates/backup-script.j2
cybersecurity-lab/roles/backup/templates/cron-jobs.j2
cybersecurity-lab/roles/backup/files/backup-scripts/.gitkeep

cybersecurity-lab/roles/tailscale/tasks/main.yml
cybersecurity-lab/roles/tailscale/tasks/install.yml
cybersecurity-lab/roles/tailscale/tasks/authenticate.yml
cybersecurity-lab/roles/tailscale/tasks/subnet-routes.yml
cybersecurity-lab/roles/tailscale/tasks/acls.yml
cybersecurity-lab/roles/tailscale/templates/tailscale-config.j2
cybersecurity-lab/roles/tailscale/defaults/main.yml

cybersecurity-lab/roles/compliance/tasks/main.yml
cybersecurity-lab/roles/compliance/tasks/nist-audit.yml
cybersecurity-lab/roles/compliance/tasks/security-baseline.yml
cybersecurity-lab/roles/compliance/tasks/vulnerability-scan.yml
cybersecurity-lab/roles/compliance/tasks/report-generation.yml
cybersecurity-lab/roles/compliance/templates/compliance-report.j2
cybersecurity-lab/roles/compliance/files/audit-scripts/.gitkeep

cybersecurity-lab/collections/requirements.yml

cybersecurity-lab/library/proxmox_vm_advanced.py
cybersecurity-lab/library/opnsense_config.py
cybersecurity-lab/library/security_onion_rule.py

cybersecurity-lab/filter_plugins/network.py
cybersecurity-lab/filter_plugins/security.py

cybersecurity-lab/scripts/setup/00-prepare-control-node.sh
cybersecurity-lab/scripts/setup/01-generate-ssh-keys.sh
cybersecurity-lab/scripts/setup/02-deploy-ssh-keys.sh
cybersecurity-lab/scripts/setup/03-test-connectivity.sh

cybersecurity-lab/scripts/wrappers/deploy-full-lab.sh
cybersecurity-lab/scripts/wrappers/deploy-single-vm.sh
cybersecurity-lab/scripts/wrappers/update-all.sh
cybersecurity-lab/scripts/wrappers/backup-now.sh
cybersecurity-lab/scripts/wrappers/health-check.sh

cybersecurity-lab/scripts/maintenance/snapshot-before-change.sh
cybersecurity-lab/scripts/maintenance/rollback-snapshot.sh
cybersecurity-lab/scripts/maintenance/cleanup-old-snapshots.sh

cybersecurity-lab/scripts/utilities/get-vm-info.sh
cybersecurity-lab/scripts/utilities/console-connect.sh
cybersecurity-lab/scripts/utilities/generate-inventory.sh

cybersecurity-lab/files/iso/README.md
cybersecurity-lab/files/keys/.gitkeep
cybersecurity-lab/files/keys/README.md
cybersecurity-lab/files/configs/static-configs/.gitkeep
cybersecurity-lab/files/scripts/utility-scripts/.gitkeep

cybersecurity-lab/templates/documentation/vm-documentation.md.j2
cybersecurity-lab/templates/documentation/network-map.md.j2
cybersecurity-lab/templates/reports/health-report.html.j2
cybersecurity-lab/templates/reports/compliance-report.html.j2

cybersecurity-lab/vars/networks.yml
cybersecurity-lab/vars/vms.yml
cybersecurity-lab/vars/tools.yml
cybersecurity-lab/vars/compliance.yml

cybersecurity-lab/secrets/.gitkeep
cybersecurity-lab/secrets/README.md
cybersecurity-lab/secrets/.env.example
cybersecurity-lab/secrets/vault-password.txt
cybersecurity-lab/secrets/encrypted/passwords.yml
cybersecurity-lab/secrets/encrypted/api_keys.yml
cybersecurity-lab/secrets/encrypted/certificates/.gitkeep

cybersecurity-lab/logs/.gitkeep
cybersecurity-lab/logs/README.md

cybersecurity-lab/backups/.gitkeep
cybersecurity-lab/backups/README.md

cybersecurity-lab/tests/inventory/test-hosts.yml
cybersecurity-lab/tests/test-playbooks/test-connectivity.yml
cybersecurity-lab/tests/test-playbooks/test-vm-creation.yml
cybersecurity-lab/tests/test-playbooks/test-hardening.yml
cybersecurity-lab/tests/integration/test-full-deployment.yml
cybersecurity-lab/tests/integration/test-backup-restore.yml
MAN
)

echo "Running in mode: $( [[ $DRY_RUN -eq 1 ]] && echo DRY-RUN || echo EXECUTE )"

while IFS= read -r entry; do
  [[ -z "$entry" ]] && continue
  # strip leading "cybersecurity-lab/" when making dirs under $TARGET
  rel=${entry#cybersecurity-lab/}
  dir=$(dirname "$rel")
  mkdir -p "$TARGET/$dir"

  # if entry ends with / (directory), continue
  if [[ "$entry" =~ /$ ]] ; then
    continue
  fi

  target_path="$TARGET/$rel"
  if [[ -e "$target_path" ]]; then
    echo "SKIP (exists): $target_path"
    continue
  fi

  name=$(basename "$rel")
  # search for a candidate file in current tree excluding target dir
  candidate=$(find . -path "./$TARGET" -prune -o -type f -name "$name" -print -quit || true)

  if [[ -z "$candidate" ]]; then
    echo "NOT FOUND: $entry"
    continue
  fi

  echo "MAP: $candidate -> $target_path"
  if [[ $DRY_RUN -eq 0 ]]; then
    mkdir -p "$(dirname "$target_path")"
    mv "$candidate" "$target_path"
  fi
done <<EOF
$manifest
EOF

echo "Done. Review $TARGET. Rerun with --execute to perform moves."
