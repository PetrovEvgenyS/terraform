variable "libvirt_uri" {
  type        = string
  default     = "qemu:///system"  # Значение по умолчанию для подключения к локальному KVM/QEMU.
  description = "URI для подключения к гипервизору libvirt"
}

variable "prefix" {
  type = string
  description = "Префикс для именования ресурсов"
}

variable "pool" {
  type = object({
    name      = string      # Имя пула хранения.
    type      = string      # Тип пула (например, "dir" для директории).
    pool_path = string      # Путь к директории пула хранения на хосте.
  })
  description = "Конфигурация пула хранения для дисков VM"
}

variable "image" {
  type = object({
    name   = string         # Имя исходного образа.
    path   = string         # Путь к файлу образа на хосте.
    format = string         # Формат образа (например, "qcow2").
  })
  description = "Конфигурация исходного образа диска VM"
}

variable "vm_count" {
  type        = number
  default     = 1           # По умолчанию создается 1 ВМ.
  description = "Количество VM для создания"
}

variable "vm" {
  type = object({
    name       = string     # Имя виртуальной машины.
    cpu        = number     # Количество виртуальных CPU.
    ram        = number     # Объем оперативной памяти в мегабайтах.
    disk       = number     # Размер диска в байтах.
    arch       = string     # Архитектура VM (например, "x86_64").
    bridge     = string     # Имя сетевого моста для подключения VM.
    autostart  = bool       # Флаг автоматического запуска VM при старте хоста.
    qemu_agent = bool       # Флаг включения QEMU Guest Agent для взаимодействия с VM.
  })
  description = "Основные параметры виртуальной машины"
}

variable "user_login" {
  type        = string
  description = "Логин пользователя для доступа к VM"
}

variable "user_password" {
  type        = string
  description = "Пароль пользователя для доступа к VM"
  sensitive   = true    # Флаг, указывающий, что значение конфиденциально и не отображается в логах.
}

variable "network_mode" {
  type        = string
  description = "Режим настройки сети: 'static' или 'dhcp'"     # Описание: определяет, будет ли IP статическим или динамическим.
  default     = "static"                                        # Значение по умолчанию — статический IP.
  validation {                                                  # Блок валидации для проверки корректности значения.
    condition     = contains(["static", "dhcp"], var.network_mode)    # Условие: значение должно быть "static" или "dhcp".
    error_message = "network_mode должен быть 'static' или 'dhcp'."   # Сообщение об ошибке при неверном значении.
  }
}

variable "network" {
  type = object({
    address = optional(string, null)      # IP-адрес VM (опционально, null для DHCP).
    mask    = optional(string, null)      # Маска подсети (опционально, null для DHCP).
    gateway = optional(string, null)      # Шлюз по умолчанию (опционально, null для DHCP).
    dns     = optional(string, null)      # DNS-сервер (опционально, null для DHCP).
  })
  description = "Network configuration"
}