# Main Terraform configuration for vSphere mixed VM deployment
terraform {
  required_version = ">= 1.0"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.4.0"
    }
  }
}

# Configure the VMware vSphere Provider
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.allow_unverified_ssl
}

# Data sources for vSphere objects
data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

# VM Templates
data "vsphere_virtual_machine" "windows_template" {
  name          = var.windows_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "linux_template" {
  name          = var.linux_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Windows Server VMs
resource "vsphere_virtual_machine" "windows_vm" {
  count            = var.windows_vm_count
  name             = "${var.windows_vm_prefix}-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vm_folder1

  num_cpus = var.windows_vm_cpu
  memory   = var.windows_vm_memory
  guest_id = data.vsphere_virtual_machine.windows_template.guest_id

  scsi_type = data.vsphere_virtual_machine.windows_template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.windows_template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = var.windows_vm_disk_size
    eagerly_scrub    = data.vsphere_virtual_machine.windows_template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.windows_template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.windows_template.id

    customize {
      windows_options {
        computer_name         = "${var.windows_vm_prefix}-${count.index + 1}"
        admin_password        = var.windows_admin_password
        auto_logon            = true
        auto_logon_count      = 1
        time_zone             = var.windows_timezone
        run_once_command_list = var.windows_run_once_commands
      }

      network_interface {
        ipv4_address = length(var.windows_vm_ips) > count.index ? var.windows_vm_ips[count.index] : null
        ipv4_netmask = var.ipv4_netmask
      }

      ipv4_gateway    = var.ipv4_gateway
      dns_server_list = var.dns_servers
    }
  }

  tags = [
    vsphere_tag.os_windows.id,
    vsphere_tag.environment.id
  ]
}

# Linux VMs
resource "vsphere_virtual_machine" "linux_vm" {
  count            = var.linux_vm_count
  name             = "${var.linux_vm_prefix}-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vm_folder2

  num_cpus = var.linux_vm_cpu
  memory   = var.linux_vm_memory
  guest_id = data.vsphere_virtual_machine.linux_template.guest_id

  scsi_type = data.vsphere_virtual_machine.linux_template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.linux_template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = var.linux_vm_disk_size
    eagerly_scrub    = data.vsphere_virtual_machine.linux_template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.linux_template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.linux_template.id

    customize {
      linux_options {
        host_name = "${var.linux_vm_prefix}-${count.index + 1}"
        domain    = var.domain_name
      }

      network_interface {
        ipv4_address = length(var.linux_vm_ips) > count.index ? var.linux_vm_ips[count.index] : null
        ipv4_netmask = var.ipv4_netmask
      }

      ipv4_gateway    = var.ipv4_gateway
      dns_server_list = var.dns_servers
    }
  }

  tags = [
    vsphere_tag.os_linux.id,
    vsphere_tag.environment.id
  ]
}

# Tags for VM organization
resource "vsphere_tag_category" "category" {
  name               = "Operating System"
  cardinality        = "SINGLE"
  description        = "Operating System category for VMs"
  associable_types   = ["VirtualMachine"]
}

resource "vsphere_tag_category" "environment_category" {
  name               = "Environment"
  cardinality        = "SINGLE"
  description        = "Environment category for VMs"
  associable_types   = ["VirtualMachine"]
}

resource "vsphere_tag" "os_windows" {
  name        = "Windows"
  category_id = vsphere_tag_category.category.id
  description = "Windows Operating System"
}

resource "vsphere_tag" "os_linux" {
  name        = "Linux"
  category_id = vsphere_tag_category.category.id
  description = "Linux Operating System"
}

resource "vsphere_tag" "environment" {
  name        = var.environment_tag
  category_id = vsphere_tag_category.environment_category.id
  description = "Environment tag for VM classification"
}
