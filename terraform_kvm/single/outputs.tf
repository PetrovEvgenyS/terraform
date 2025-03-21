# Выходные данные: Имя созданной виртуальной машины
output "vm_name" {
  description = "Name of the created VM"            # Описание выходного значения
  value       = libvirt_domain.vm.name              # Значение: имя VM из ресурса
}

# Выходные данные: ID созданного диска
output "disk_id" {
  description = "ID of the created disk volume"     # Описание выходного значения
  value       = libvirt_volume.vm_disk.id           # Значение: ID диска из ресурса
}