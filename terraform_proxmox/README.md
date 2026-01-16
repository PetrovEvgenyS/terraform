# Terraform для Proxmox VE


## Установка плагина

```bash
mkdir -p ~/.terraform.d/plugins/registry.terraform.io/telmate/proxmox/3.0.2-rc07/linux_amd64
wget https://github.com/Telmate/terraform-provider-proxmox/releases/download/v3.0.2-rc07/terraform-provider-proxmox_3.0.2-rc07_linux_amd64.zip
unzip terraform-provider-proxmox_3.0.2-rc07_linux_amd64.zip -d ~/.terraform.d/plugins/registry.terraform.io/telmate/proxmox/3.0.2-rc07/linux_amd64
rm -f ~/terraform-provider-proxmox_3.0.2-rc07_linux_amd64.zip
```


## Настройка шаблона

```bash
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
mv noble-server-cloudimg-amd64.img noble-server-cloudimg-amd64.qcow2

qemu-img resize noble-server-cloudimg-amd64.qcow2 20G

qm disk import 9000 noble-server-cloudimg-amd64.qcow2 nvme





qm set 9000 --scsi0 nvmem:cloudinit


qm set 9000 --boot order=scsi0


10.100.10.251, 10.100.10.252, 10.100.10.254

ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMShkftNYhOkXJfzc3FMu8yzL1dEfQ1D2+twugzaV61A user@HomePC01
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjQv07ai7Jn44s+gkrBg7HAy9F+2BKwcGifnAiyiEK/ root@main.local

qm template 9000

```