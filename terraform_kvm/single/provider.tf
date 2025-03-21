# Конфигурация провайдера libvirt
provider "libvirt" {
  uri = "qemu:///system"  # URI для подключения к локальному hypervisor'у KVM/QEMU через системный сокет
}