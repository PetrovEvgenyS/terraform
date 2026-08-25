# Terraform / OpenTofu — ВМ на KVM и Proxmox

Конфиги для создания виртуальных машин: **KVM/QEMU (libvirt)** и **Proxmox VE**.

## Что где лежит

| Каталог | Назначение |
|---------|------------|
| `terraform_kvm/single/` | Одна ВМ на KVM |
| `terraform_kvm/multi/` | Несколько ВМ на KVM |
| `terraform_proxmox/` | ВМ в Proxmox (клон cloud-init шаблона) |
| `!tools/` | Скрипты установки Terraform / OpenTofu / плагинов |

Подробности по Proxmox — в [`terraform_proxmox/README.md`](terraform_proxmox/README.md).

## Что нужно заранее

**KVM:** Terraform (или OpenTofu), работающий libvirt, мост `br0`, образ qcow2 (по умолчанию `/opt/kvm/images/almalinux.qcow2`).

**Proxmox:** API-доступ к ноде, шаблон ВМ, токен/учётка — см. README в `terraform_proxmox/`.

### Установка инструментов (Linux)

```bash
bash !tools/install_terraform.sh      # или install_opentofu.sh
bash !tools/install_plugin_libvirt.sh # для KVM
```

Остальные скрипты — в [`!tools/README.md`](!tools/README.md).

## Быстрый старт (KVM)

```bash
cd terraform_kvm/single   # или terraform_kvm/multi

# пароль пользователя ВМ (не коммитить в tfvars)
export TF_VAR_user_password="секрет"

# при необходимости поправить terraform.tfvars
# (имя ВМ, CPU/RAM, путь к образу, сеть dhcp/static)

terraform init
terraform plan
terraform apply
```

Удаление:

```bash
terraform destroy
```

## Образы ОС (KVM)

- [AlmaLinux Cloud](https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/)
- [Ubuntu Cloud](https://cloud-images.ubuntu.com/)
