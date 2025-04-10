libvirt_uri = "qemu:///system"     # URI для подключения к локальному KVM/QEMU.
                                   # For ssh, use: libvirt_uri = "qemu+ssh://user@remote_host/system"
prefix = "test-"                   # Префикс для именования ресурсов (например, "test-alma-vm01").

pool = {                           # Конфигурация пула хранения.
  name      = "data"               # Имя пула.
  type      = "dir"                # Тип пула — директория.
  pool_path = "/opt/kvm/volumes/"  # Путь к директории на хосте для хранения дисков.
}

image = {                          # Конфигурация исходного образа.
  name   = "almalinux"             # Имя образа.
  path   = "/opt/kvm/images/almalinux.qcow2"  # Путь к файлу образа на хосте.
  format = "qcow2"                 # Формат образа — qcow2 (диск с поддержкой копирования при записи).
}

vm_count = 3                       # Создать 3 ВМ.

vm = {                             # Конфигурация виртуальной машины.
  name       = "alma-vm0"          # Имя VM.
  cpu        = 2                   # Количество виртуальных CPU.
  ram        = 2048                # Оперативная память в мегабайтах (2 ГБ).
  disk       = 1024 * 1024 * 1024 * 10  # Размер диска в байтах (10 ГБ).
  arch       = "x86_64"            # Архитектура процессора.
  bridge     = "br0"               # Сетевой мост для подключения VM.
  autostart  = true                # Автоматический запуск VM при старте хоста.
  qemu_agent = true                # Включение QEMU Guest Agent.
}

user_login = "admin"               # Логин пользователя для VM.

### Настройка сети ###
# Настройка статики:
# network_mode = "static"            # Режим сети — статический IP.
# network = {                        # Параметры сети для статической конфигурации.
#   address = "10.100.10.150"        # IP-адрес.
#   mask    = "24"                   # Маска подсети.
#   gateway = "10.100.10.254"        # Шлюз по умолчанию.
#   dns     = "10.100.10.254"        # DNS-сервер.
# }

# Пример для DHCP:
network_mode = "dhcp"            # Альтернативный режим — динамический IP.
network = {}                     # Пустой объект для DHCP (без статических параметров).