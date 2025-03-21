# Terraform Project for VM Deployment

This project deploys a virtual machine using libvirt provider on a KVM/QEMU hypervisor.

## Prerequisites
- Terraform installed
- Libvirt running on the system
- Almalinux 9 template at /opt/kvm/almalinux9-template.qcow2
- Storage pool named "data"
- Network bridge "br0"