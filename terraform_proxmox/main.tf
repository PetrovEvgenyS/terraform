resource "proxmox_vm_qemu" "vm" {
  count            = var.vm_count
  vmid             = var.vm_first_id + count.index
  name             = format("%s-%02d", var.vm_name_prefix, count.index + 1)
  target_node      = var.vm_target_node
  clone            = var.vm_template
  full_clone       = true
  bios             = "ovmf" # seabios
  agent            = 1
  scsihw           = "virtio-scsi-single"
  power_state      = "running"
  automatic_reboot = true
  memory           = 2048


  cpu {
    cores          = 2
    sockets        = 1
  }

  network {
    id             = 0
    model          = "virtio"
    bridge         = "vmbr0"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage  = var.vm_storage
          size     = "20"
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage  = var.vm_storage
        }
      }
    }
  }

  os_type          = "cloud-init"
  ciuser           = var.ciuser
  cipassword       = var.cipassword
  sshkeys          = var.sshkeys
  nameserver       = var.nameserver
  searchdomain     = var.searchdomain
  ciupgrade        = var.ciupgrade
  ipconfig0        = "ip=${cidrhost(var.vm_network_cidr, var.vm_first_host + count.index)}/24,gw=${var.vm_gateway}"
}
