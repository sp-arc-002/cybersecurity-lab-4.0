# Copilot / AI Agent Instructions

Brief, actionable guidance for AI coding agents working in this repository.

1) Big picture
- This repo is a lab infrastructure repository (Proxmox, OPNsense, Security Onion, VMs) with two IaC approaches: `ansible/` (primary) and `terraform/` (alternative).
- Configuration artifacts live in `configs/`; automation scripts in `scripts/`; templates in `templates/` and `ansible/templates/` (Jinja2).
- `ansible/roles/` contains service-specific roles (naming: `proxmox`, `opnsense`, `security-onion`, `blackarch`, `remnux`, `openbsd`, `common`). Playbooks are ordered by numeric prefix (e.g., `00-...`, `01-...`) — maintain ordering when adding new initialisation steps.

2) Primary workflows & commands (examples you can run)
- Run the first-time Ansible setup:
  ```bash
  ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/00-initial-setup.yml
  ```
- Configure Proxmox via Ansible playbook:
  ```bash
  ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/01-proxmox-config.yml
  ```
- Terraform quick checks:
  ```bash
  terraform -chdir=terraform init
  terraform -chdir=terraform plan
  ```
- Run project CLI (Python):
  ```bash
  pip install -r tools/lab-cli/requirements.txt
  python tools/lab-cli/lab-cli.py --help
  ```
- Run tests:
  - Python unit tests: `pytest tests/unit` (requires Python & pytest)
  - Shell integration tests: run the script directly, e.g. `bash tests/integration/test_vm_connectivity.sh`

3) Project-specific conventions and patterns
- Playbook ordering: filenames are prefixed with a numeric order (e.g., `00-`, `01-`) — do not rely on alphabetical order.
- Jinja2 templates in `ansible/templates/` use variables defined under `ansible/inventory/group_vars/` (e.g., `all.yml`, `proxmox.yml`, `vms.yml`). When adding new template variables, update matching group_vars files.
- Roles: keep role responsibilities narrow (one service per role). Tests and idempotence checks should be added to a role's `tasks/` and `handlers/` where appropriate.
- Configs that are sanitized for privacy (OPNsense `config.xml`, `proxmox` templates) are tracked under `configs/` — do not reintroduce secrets.
- Secrets: files in `secrets/` are intentionally gitignored. If you need to add secret examples, use `secrets/.env.example`.

4) Integration & external dependencies to be aware of
- Proxmox: integrations live in `ansible/roles/proxmox` and `terraform/modules/proxmox-vm`. Look for provider configuration under `terraform/providers.tf` when using Terraform.
- OPNsense: `configs/opnsense/config.xml` and related firewall XMLs are the canonical export — playbooks and templates load config XMLs for idempotent restores.
- Monitoring: Prometheus and Grafana configs are in `monitoring/` — dashboards and alerting rules are authoritative here.
- Tailscale: `configs/tailscale/` contains ACLs and subnet routes used by automation scripts (`scripts/setup/05-install-tailscale.sh`).

5) Where to make changes (practical pointers)
- Add new playbooks to `ansible/playbooks/` using numeric prefixes.
- Add new Terraform modules under `terraform/modules/` and reference them from `terraform/main.tf` or `terraform/environments/`.
- Add CLI subcommands under `tools/lab-cli/commands/` and update `tools/lab-cli/requirements.txt` for new deps.
- Add unit tests to `tests/unit/` and integration checks to `tests/integration/` alongside automation scripts.

6) Merging guidance if this file already exists
- Preserve any human-written sections (top-of-file notes or sign-offs). Insert or update the sections above under a new header `## Updated AI agent notes` and include a short changelog line with date and author.

7) Quick troubleshooting tips for agents
- If an Ansible run fails, check `ansible.cfg` and `ansible/inventory/hosts.yml` for connectivity and variable overrides.
- For Terraform issues, run `terraform -chdir=terraform validate` and inspect provider versions in `terraform/providers.tf`.
- For script failures, ensure executable bits: `chmod +x scripts/...` and run with `bash -x` to trace.

8) Ask before making large structural changes
- Do not add or remove major top-level directories (`ansible/`, `terraform/`, `configs/`, `scripts/`, `templates/`, `monitoring/`) without explicit user confirmation. If a change affects live lab infra (Proxmox, OPNsense, Security Onion), request confirmation and a backup snapshot.

If any section is unclear or you want me to generate a skeleton of the full file tree, tell me which depth (only directories, directories+placeholder files, or full empty-file tree) and I'll create it.
