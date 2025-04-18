# Terraform Project for VM Deployment

This project deploys a virtual machine using libvirt provider on a KVM/QEMU hypervisor.

## Prerequisites
- Terraform installed
- Libvirt running on the system
- Almalinux 9 template at /opt/kvm/images/almalinux.qcow2
- Network bridge "br0"

## Images

| Name |
|------|
| [Almalinux](https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/) |
| [Ubuntu](https://cloud-images.ubuntu.com/) |

## Enter the password via:

```bash
export TF_VAR_user_password="my_secrete_ password"
```
