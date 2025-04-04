# Этот ресурс создает пул хранения в libvirt, который используется для размещения дисков и ISO-образов.
resource "libvirt_pool" "pool" {
  name = var.pool.name          # Имя пула хранения из переменной.
  type = var.pool.type          # Тип пула (например, "dir").
  target {                      # Блок для указания параметров пула.
    path = var.pool.pool_path   # Путь к директории пула на хосте.
  }
}

# Этот ресурс загружает исходный образ в пул хранения, чтобы его можно было использовать как основу для дисков VM.
resource "libvirt_volume" "image" {
  name   = var.image.name       # Имя исходного образа.
  format = var.image.format     # Формат образа (например, "qcow2").
  pool   = libvirt_pool.pool.name  # Пул хранения, куда загружается образ.
  source = var.image.path       # Путь к исходному файлу образа на хосте.
}

# Этот ресурс создает диск для VM, копируя базовый образ и расширяя его до нужного размера.
resource "libvirt_volume" "vm_disk" {
  name           = "${var.prefix}${var.vm.name}"  # Имя диска VM (префикс + имя VM).
  pool           = libvirt_pool.pool.name         # Пул хранения для диска.
  base_volume_id = libvirt_volume.image.id        # ID базового образа, от которого создается диск.
  size           = var.vm.disk                    # Размер диска в байтах.
}

# Этот ресурс создает ISO-образ с конфигурацией cloud-init, который используется для автоматической настройки VM при первом запуске.
resource "libvirt_cloudinit_disk" "cloudinit" {
  name      = "cloudinit.iso"           # Имя ISO-файла с конфигурацией cloud-init.
  pool      = libvirt_pool.pool.name    # Пул хранения для ISO-файла.
  user_data = templatefile("${path.module}/templates/cloud-init.tpl", {  # Генерация cloud-init из шаблона.
    hostname       = var.vm.name        # Имя хоста VM.
    user_login     = var.user_login     # Логин пользователя.
    user_password  = var.user_password  # Пароль пользователя.
    network        = var.network        # Параметры сети.
    network_mode   = var.network_mode   # Режим сети (static/dhcp).
    uuid           = uuid()             # Функция генерации уникального UUID для сетевого интерфейса.
  })
}

# Этот ресурс полностью описывает VM, включая CPU, память, диск, сеть и доступ.
resource "libvirt_domain" "vm" {
  name       = "${var.prefix}${var.vm.name}"  # Полное имя VM (префикс + имя).
  memory     = var.vm.ram                     # Оперативная память в мегабайтах.
  vcpu       = var.vm.cpu                     # Количество виртуальных CPU.
  arch       = var.vm.arch                    # Архитектура VM.
  autostart  = var.vm.autostart               # Флаг автозапуска.
  qemu_agent = var.vm.qemu_agent              # Включение QEMU Guest Agent.
  
  cpu {                                       # Конфигурация CPU.
    mode = "host-passthrough"                 # Режим CPU: передача характеристик хоста для лучшей производительности.
  }

  disk {                                      # Блок диска VM.
    volume_id = libvirt_volume.vm_disk.id     # ID диска из ресурса `libvirt_volume`.
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit.id  # Подключение cloud-init ISO к VM.
  
  network_interface {             # Конфигурация сетевого интерфейса.
    bridge   = var.vm.bridge      # Сетевой мост для подключения.
    wait_for_lease = true         # Ожидание получения IP-адреса (для вывода в outputs).
  }

  console {                       # Конфигурация консоли VM.
    type        = "pty"           # Тип консоли — псевдотерминал.
    target_type = "serial"        # Цель — серийный порт.
    target_port = "0"             # Номер порта (0 — первый серийный порт).
  }

  graphics {                      # Конфигурация графического доступа (VNC).
    type          = "vnc"         # Тип графики — VNC.
    listen_type   = "address"     # Тип прослушивания — по адресу.
    listen_address = "127.0.0.1"  # Адрес прослушивания — только локальный доступ.
  }
}