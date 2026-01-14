## Terraform для KVM/QEMU

Репозиторий содержит набор конфигураций Terraform для развёртывания виртуальных машин на гипервизоре KVM/QEMU с использованием провайдера `libvirt`.

### Структура репозитория

- **`!tools/`**  
  - `install_plugin_libvirt.sh` — установка плагина `terraform-provider-libvirt`.  
  - `install_terraform_almalinux.sh` — установка Terraform в AlmaLinux.

- **`terraform_kvm/single/`**  
  - Развёртывание **одной** виртуальной машины (одиночный узел) на KVM/QEMU.

- **`terraform_kvm/multi/`**  
  - Развёртывание **нескольких** виртуальных машин (кластер/группа) на KVM/QEMU.

Подробнее о переменных, примерах и настройках см. в `README.md` внутри каталогов `single` и `multi`.

### Предварительные требования

- Установленный **Terraform**.  
- Запущенный и настроенный **libvirt** на хостовой системе.  
- Образ AlmaLinux 9 (qcow2) по пути `/opt/kvm/images/almalinux.qcow2` или свой путь, указанный в `terraform.tfvars`.  
- Сетевой мост, например `br0`, настроенный на хосте.

### Быстрый старт

1. Перейдите в нужный каталог:
   - для одной ВМ: `terraform_kvm/single/`
   - для нескольких ВМ: `terraform_kvm/multi/`
2. Отредактируйте `terraform.tfvars` под свою среду (имя ВМ, ресурсы, сеть и т.д.).
3. Передайте пароль пользователя через переменную окружения:

   ```bash
   export TF_VAR_user_password="мой_секретный_пароль"
   ```

4. Выполните стандартные команды Terraform:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

### Образы ОС

- AlmaLinux: `https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/`  
- Ubuntu: `https://cloud-images.ubuntu.com/`
