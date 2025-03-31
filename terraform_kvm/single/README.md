# Terraform Project for VM Deployment

This project deploys a virtual machine using libvirt provider on a KVM/QEMU hypervisor.

## Prerequisites
- Terraform installed
- Libvirt running on the system
- Almalinux 9 template at /opt/kvm/almalinux.qcow2
- Network bridge "br0"

## Images

| Name |
|------|
| [Almalinux](https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/) |
| [Ubuntu](https://cloud-images.ubuntu.com/) |

## Enter the password via:

export TF_VAR_password="мой_секретный_пароль"
