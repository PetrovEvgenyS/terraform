# Определение версии Terraform и необходимых провайдеров
terraform {
  required_providers {
    # Провайдер libvirt для управления виртуальными машинами через KVM/QEMU
    libvirt = {
      source  = "dmacvicar/libvirt"  # Источник провайдера в Terraform Registry
      version = "0.8.3"              # Фиксированная версия провайдера
    }
  }
}