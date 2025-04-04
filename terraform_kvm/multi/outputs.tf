output "vm_name" {
  description = "Name of the created VM"
  value       = libvirt_domain.vm[*].name  # Список всех имён VM в гипервизоре.
}

output "vm_ip" {
  value       = [for vm in libvirt_domain.vm : try(vm.network_interface[0].addresses[0], "IP not assigned yet")]
  description = "Список IPv4-адресов. Значение: первый IP-адрес или сообщение, если IP еще не назначен."
}