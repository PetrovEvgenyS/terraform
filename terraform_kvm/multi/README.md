# Terraform Project for VM Deployment

This project deploys a virtual machine using libvirt provider on a KVM/QEMU hypervisor.

## Prerequisites
- Terraform installed
- Libvirt running on the system
- Almalinux 9 template at /opt/kvm/images/almalinux.qcow2
- Network bridge "br0"

## Images

| Name |
|------|
| [Almalinux](https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/) |
| [Ubuntu](https://cloud-images.ubuntu.com/) |

## Enter the password via:

```bash
export TF_VAR_user_password="my_secrete_ password"
```

## Разбор блока "network":
```hcl
resource "libvirt_cloudinit_disk" "cloudinit" {
  count = var.vm_count
  name  = "cloudinit-${count.index + 1}.iso"  # Уникальное имя ISO-файла с конфигурацией cloud-init для каждой VM.
  pool  = libvirt_pool.pool.name              # Пул хранения для ISO-файла.
  user_data = templatefile("${path.module}/templates/cloud-init.tpl", {  # Генерация cloud-init из шаблона.
    hostname       = "${var.vm.name}${count.index + 1}"                  # Уникальное имя хоста: alma-vm0, alma-vm1...
    user_login     = var.user_login     # Логин пользователя.
    user_password  = var.user_password  # Пароль пользователя.
    network        = var.network_mode == "static" ? {
      address = cidrhost("${var.network.address}/${var.network.mask}", parseint(element(split(".", var.network.address), 3), 10) + count.index + 1)
      mask    = var.network.mask        # Маска сети.
      gateway = var.network.gateway     # Шлюз по умолчанию.
      dns     = var.network.dns         # DNS.
    } : {}
    network_mode   = var.network_mode   # Режим сети (static/dhcp).
    uuid           = uuid()             # Функция генерации уникального UUID для сетевого интерфейса.
  })
}
```

Этот код задаёт сетевые настройки для cloud-init в зависимости от network_mode:

- Если network_mode = "static":
  - var.network.address — это начальный IP, например, "10.100.10.150".
  - var.network.mask — это маска подсети, например, "24".
  - "${var.network.address}/${var.network.mask}" — объединяет их в CIDR: "10.100.10.150/24". Это говорит, что мы работаем в подсети 10.100.10.0/24.
  - split(".", var.network.address) — разбивает IP на части: ["10", "100", "10", "150"].
  - element(..., 3) — берёт последний октет: "150". Функция element() берёт элемент из списка по указанному индексу. Здесь индекс — 3, равный четвёртому октеку, т.е. 150.
  - parseint(..., 10) — превращает строку "150" в число 150. Функция parseint() преобразует строку в число. Первый аргумент — строка (у нас "150"), второй — основание системы счисления (у нас 10, десятичная).
  - "+ count.index + 1" — прибавляет к 150 номер ВМ, начиная с 1:
    - Если count.index = 0 → 150 + 0 + 1 = 151.
    - Если count.index = 1 → 150 + 1 + 1 = 152.
  - cidrhost("10.100.10.150/24", 151) — берёт подсеть 10.100.10.0/24 и выдаёт IP с номером хоста 151, то есть 10.100.10.151.
  - address: в итоге равен 10.100.10.151.

- mask: берёт var.network.mask (например, "24").
- gateway: берёт var.network.gateway (например, "10.100.10.254").
- dns: берёт var.network.dns (например, "10.100.10.254").

- Если network_mode != "static" (например, "dhcp"):
  - Возвращает пустую карту {} — сеть настраивается автоматически.

