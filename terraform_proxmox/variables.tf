variable "vm_count" {
  description = "Количество ВМ"
  type        = number
  default     = 2
}

variable "vm_name_prefix" {
  description = "Префикс имени ВМ"
  type        = string
  default     = "vm"
}

variable "vm_target_node" {
  description = "Узел Proxmox"
  type        = string
  default     = "pve-01"
}

variable "vm_template" {
  description = "Имя шаблона/ВМ в Proxmox (параметр clone, например cloud-init)"
  type        = string
  default     = "cloud-init"
}

variable "vm_storage" {
  description = "Основное хранилище для дисков ВМ"
  type        = string
  default     = "nvme"
}

variable "vm_gateway" {
  description = "Шлюз IPv4 для ВМ"
  type        = string
  default     = "10.100.10.254"
}

variable "vm_network_cidr" {
  description = "Подсеть IPv4/CIDR для ВМ"
  type        = string
  default     = "10.100.10.0/24"
}

variable "vm_first_host" {
  description = "Номер первого хоста в подсети для первой ВМ"
  type        = number
  default     = 131
}

variable "vm_first_id" {
  description = "ID первой ВМ в Proxmox"
  type        = number
  default     = 400
}

