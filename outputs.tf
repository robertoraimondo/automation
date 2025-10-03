# Output information about created VMs

# Windows VMs Outputs
output "windows_vm_names" {
  description = "Names of the Windows VMs"
  value       = vsphere_virtual_machine.windows_vm[*].name
}

output "windows_vm_ips" {
  description = "IP addresses of the Windows VMs"
  value       = vsphere_virtual_machine.windows_vm[*].default_ip_address
}

output "windows_vm_uuids" {
  description = "UUIDs of the Windows VMs"
  value       = vsphere_virtual_machine.windows_vm[*].uuid
}

# Linux VMs Outputs
output "linux_vm_names" {
  description = "Names of the Linux VMs"
  value       = vsphere_virtual_machine.linux_vm[*].name
}

output "linux_vm_ips" {
  description = "IP addresses of the Linux VMs"
  value       = vsphere_virtual_machine.linux_vm[*].default_ip_address
}

output "linux_vm_uuids" {
  description = "UUIDs of the Linux VMs"
  value       = vsphere_virtual_machine.linux_vm[*].uuid
}

# Combined outputs for all VMs
output "all_vm_summary" {
  description = "Summary of all created VMs"
  value = {
    windows_vms = {
      count = length(vsphere_virtual_machine.windows_vm)
      names = vsphere_virtual_machine.windows_vm[*].name
      ips   = vsphere_virtual_machine.windows_vm[*].default_ip_address
    }
    linux_vms = {
      count = length(vsphere_virtual_machine.linux_vm)
      names = vsphere_virtual_machine.linux_vm[*].name
      ips   = vsphere_virtual_machine.linux_vm[*].default_ip_address
    }
  }
}

# Infrastructure outputs
output "datacenter_name" {
  description = "Name of the datacenter"
  value       = data.vsphere_datacenter.dc.name
}

output "cluster_name" {
  description = "Name of the cluster"
  value       = data.vsphere_compute_cluster.cluster.name
}

output "datastore_name" {
  description = "Name of the datastore"
  value       = data.vsphere_datastore.datastore.name
}

output "network_name" {
  description = "Name of the network"
  value       = data.vsphere_network.network.name
}
