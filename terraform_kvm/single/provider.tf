# Конфигурация провайдера libvirt.
provider "libvirt" {
  uri = var.libvirt_uri  # URI для подключения к hypervisor'у KVM/QEMU.
}