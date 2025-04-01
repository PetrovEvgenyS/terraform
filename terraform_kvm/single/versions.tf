# Определение версии Terraform и провайдера libvirt.
terraform {
  required_version = ">= 1.11.2"     # Минимальная версия Terraform, необходимая для работы.
  required_providers {
    # Провайдер libvirt для управления виртуальными машинами через KVM/QEMU.
    libvirt = {
      source  = "dmacvicar/libvirt"  # Источник провайдера в Terraform Registry.
      version = ">= 0.8.3"           # Минимальная версия провайдера libvirt.
    }
  }
}