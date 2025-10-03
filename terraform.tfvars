# Example terraform.tfvars file
# Copy this to terraform.tfvars and update with your environment values

# vSphere Connection Settings
vsphere_user           = "administrator@vsphere.local"
vsphere_password       = "Admin123!"
vsphere_server         = "192.168.1.100"
allow_unverified_ssl   = true

# vSphere Infrastructure
datacenter             = "Datacenter"
datastore             = "nas"
cluster               = "Cluster"
network_name          = "DSwitch-VM Network"
vm_folder1             = "Windows"
vm_folder2		= "Linux"

# VM Templates (must exist in your vCenter)
windows_template      = "win22"
linux_template       = "alma"

# Windows VM Configuration
windows_vm_count      = 2
windows_vm_prefix     = "win-srv"
windows_vm_cpu        = 4
windows_vm_memory     = 8192
windows_vm_disk_size  = 90
windows_admin_password = "Admin123!"
windows_timezone      = "035"  # Eastern Time (US and Canada)
windows_vm_ips        = ["192.168.1.130", "192.168.1.131"]

# Linux VM Configuration
linux_vm_count       = 2
linux_vm_prefix      = "alma-srv"
linux_vm_cpu         = 2
linux_vm_memory      = 4096
linux_vm_disk_size   = 30
linux_vm_ips         = ["192.168.1.140", "192.168.1.141"]

# Network Configuration
ipv4_netmask          = 24
ipv4_gateway          = "192.168.1.1"
dns_servers           = ["192.168.1.1", "8.8.8.8"]
domain_name           = "mylab.local"

# Environment
environment_tag       = "Development"
