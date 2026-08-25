# Terraform для Proxmox VE

Создание виртуальных машин в Proxmox из cloud-init шаблона (Ubuntu Noble). ВМ получают статические IP, SSH-ключи и настройки через cloud-init.

---

## Требования

- Proxmox VE с доступом по API (порт 8006)
- API-токен в Proxmox (Users > пользователь > API Tokens) или пароль пользователя
- Terraform 1.x
- Для подготовки шаблона: образ Ubuntu Cloud Image, место на ноде (например, `nvme`)

---

## 1. Установка провайдера Proxmox

Обычно достаточно `terraform init` — провайдер `Telmate/proxmox` версии `3.0.2-rc09` указан в `versions.tf`.

Если `init` не скачивает провайдер (нет доступа к registry), установите вручную:

**Linux (amd64):**

```bash
# Каталог для плагина: хост/провайдер/версия/ОС_архитектура
mkdir -p ~/.terraform.d/plugins/registry.terraform.io/telmate/proxmox/3.0.2-rc09/linux_amd64

# Скачать архив провайдера с GitHub
wget https://github.com/Telmate/terraform-provider-proxmox/releases/download/v3.0.2-rc09/terraform-provider-proxmox_3.0.2-rc09_linux_amd64.zip

# Распаковать в каталог плагинов
unzip terraform-provider-proxmox_3.0.2-rc09_linux_amd64.zip -d ~/.terraform.d/plugins/registry.terraform.io/telmate/proxmox/3.0.2-rc09/linux_amd64

# Удалить архив
rm -f terraform-provider-proxmox_3.0.2-rc09_linux_amd64.zip
```

---

## 2. Подготовка шаблона в Proxmox (один раз)

Шаблон — это ВМ с ID 9000, превращённая в template. Terraform клонирует её (full clone) и настраивает через cloud-init.

### 2.0 Создать пустую ВМ с ID 9000

```bash
qm create 9000 \
  --name cloud-init \
  --machine q35 \
  --bios ovmf \
  --cpu x86-64-v2-AES \
  --cores 1 \
  --sockets 1 \
  --memory 2048 \
  --numa 0 \
  --ostype l26 \
  --scsihw virtio-scsi-single \
  --agent 1 \
  --net0 virtio,bridge=vmbr0,firewall=1
```

### 2.1 Скачать образ Ubuntu Cloud Image

```bash
# Ubuntu 24.04 LTS (Noble) — cloud image в /tmp (формат qcow2)
wget -O /tmp/noble-server-cloudimg-amd64.qcow2 https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
```

### 2.2 Увеличить размер диска образа (по желанию)

```bash
qemu-img resize /tmp/noble-server-cloudimg-amd64.qcow2 20G
```

### 2.3 Импортировать диск и привязать к ВМ 9000

- `9000` — ID созданной ВМ
- `nvme` — имя хранилища (должно совпадать с `vm_storage` в `variables.tf`)

```bash
qm set 9000 --scsi0 nvme:0,import-from=/tmp/noble-server-cloudimg-amd64.qcow2
```

### 2.4 Настроить cloud-init и загрузку

```bash
qm set 9000 --ide2 nvme:cloudinit
qm set 9000 --boot order=scsi0
```

### 2.5 Превратить ВМ в шаблон

После того как ВМ 9000 настроена (память, CPU при необходимости), конвертировать в шаблон:

```bash
qm template 9000
```

В `variables.tf` имя шаблона задаётся переменной `vm_template` (по умолчанию `"cloud-init"`). Имя шаблона в Proxmox должно совпадать с тем, что вы укажете в переменной (часто оставляют имя ВМ как «cloud-init» при создании 9000, либо укажите в Terraform фактическое имя шаблона).

**DNS (для справки при ручной настройке):** в примере использованы серверы `10.100.10.251`, `10.100.10.252`, `10.100.10.254`.  
**SSH-ключи** для доступа к созданным ВМ задаются в `main.tf` (или через переменные) в блоке `sshkeys` — добавьте свои публичные ключи.

---

## 3. Настройка Terraform

### 3.1 Подключение к Proxmox

Сейчас URL API и токен заданы напрямую в `providers.tf`. **Не коммитьте реальные секреты** — вынесите в переменные:

```hcl
# providers.tf
provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = true
}
```

Передача значений:

```bash
export TF_VAR_pm_api_url="https://10.100.10.241:8006/api2/json"
export TF_VAR_pm_api_token_id="root@pam!terraform"
export TF_VAR_pm_api_token_secret="ваш-секрет"
```

Или через `terraform.tfvars` (добавьте `*.tfvars` в `.gitignore`).

### 3.2 Переменные (variables.tf)

| Переменная         | Описание                          | По умолчанию     |
|--------------------|-----------------------------------|------------------|
| `vm_count`         | Количество создаваемых ВМ         | 2                |
| `vm_name_prefix`   | Префикс имени (vm-01, vm-02, …)   | `"vm"`           |
| `vm_target_node`   | Имя ноды Proxmox                  | `"pve-01"`       |
| `vm_template`      | Имя шаблона в Proxmox (clone)     | `"cloud-init"`   |
| `vm_storage`       | Хранилище для дисков              | `"nvme"`         |
| `vm_gateway`       | Шлюз для ВМ                       | `"10.100.10.254"`|
| `vm_network_cidr`  | Подсеть в формате CIDR            | `"10.100.10.0/24"`|
| `vm_first_host`    | Начальный последний октет IP      | 131              |
| `vm_first_id`      | Начальный VMID в Proxmox          | 400              |

IP выдаются по порядку: первая ВМ — `cidrhost(10.100.10.0/24, 131)`, вторая — `132` и т.д.

> Маска в `ipconfig0` сейчас захардкожена как `/24` в `main.tf`, независимо от CIDR.

В ресурсе `proxmox_vm_qemu` заданы `cipassword` и `sshkeys`. Для продакшена лучше вынести их в переменные и не коммитить в 
репозиторий (например, через `tfvars` в `.gitignore`).

IP выдаются по порядку: первая ВМ — `cidrhost(10.100.10.0/24, 131)` и т.д.

### 3.3 Параметры cloud-init (main.tf)

Заданы напрямую в ресурсе `proxmox_vm_qemu`:

| Параметр       | Значение / где менять                          |
|----------------|------------------------------------------------|
| `ciuser`       | `"root"`                                       |
| `cipassword`   | в `main.tf` — вынести в переменную             |
| `sshkeys`      | в `main.tf` — заменить на свои ключи           |
| `nameserver`   | `10.100.10.251 10.100.10.252 10.100.10.254`    |
| `searchdomain` | `"local"`                                      |
| `bridge`       | `"vmbr0"` (не переменная)                      |
| CPU / RAM      | 2 cores, 2048 MB (перезаписывают шаблон)       |

---

## 4. Запуск

```bash
cd terraform_proxmox
terraform init
terraform plan   # просмотр изменений
terraform apply  # создание ВМ
```

Уничтожение созданных ВМ:

```bash
terraform destroy
```
