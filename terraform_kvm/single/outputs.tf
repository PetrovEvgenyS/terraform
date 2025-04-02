output "vm_name" {
  description = "Name of the created VM"
  value       = libvirt_domain.vm.name    # Имя VM в гипервизоре.
}

output "vm_ip" {
  value       = try(libvirt_domain.vm.network_interface[0].addresses[0], "IP not assigned yet") # Значение: первый IP-адрес интерфейса
  description = "Interface IPs"                                                                 # или сообщение, если IP еще не назначен.
}