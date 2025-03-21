# Ресурс: Диск виртуальной машины
resource "libvirt_volume" "vm_disk" {
  name   = "${var.prefix}${var.image.name}"  # Имя диска (префикс + имя из image.name)
  pool   = var.pool_path                     # Пул хранения, где будет создан диск
  source = var.image.source                  # Путь к исходному шаблону диска
  format = var.image.format                  # Формат диска (например, qcow2)
}

# Ресурс: Виртуальная машина
resource "libvirt_domain" "vm" {
  name      = "${var.prefix}${var.vm.name}" # Имя VM (префикс + имя из vm.name)
  memory    = var.vm.ram                    # Объем оперативной памяти в MB
  vcpu      = var.vm.cpu                    # Количество виртуальных процессоров
  arch      = var.vm.arch                   # Архитектура процессора
  machine   = var.vm.machine                # Тип машины (например, q35)
  autostart = var.vm.autostart              # Автоматический запуск VM при перезагрузке хоста

  # Конфигурация CPU
  cpu {
    mode = "host-passthrough"               # Режим CPU: передача характеристик хост-процессора в гостевую систему
  }

  # Подключение диска к VM
  disk {
    volume_id = libvirt_volume.vm_disk.id   # ID созданного диска из ресурса libvirt_volume
  }

  # Сетевое подключение
  network_interface {
    bridge   = var.vm.bridge    # Подключение к указанному сетевому мосту (например, br0)
  }

  # Настройка консоли для доступа к VM
  console {
    type        = "pty"         # Тип консоли: псевдотерминал
    target_type = "serial"      # Целевой тип: последовательный порт
    target_port = "0"           # Номер порта (первый последовательный порт)
  }

  # Графический доступ через VNC
  graphics {
    type          = "vnc"       # Тип графики: VNC для удаленного доступа
    listen_type   = "address"   # Тип прослушивания: по адресу
    listen_address = "0.0.0.0"  # Адрес прослушивания: доступен со всех интерфейсов
  }
}