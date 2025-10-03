# vSphere Connection Variables
variable "vsphere_user" {
  description = "vSphere user name"
  type        = string
  sensitive   = true
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  description = "vSphere server"
  type        = string
}

variable "allow_unverified_ssl" {
  description = "Allow unverified SSL certificates"
  type        = bool
  default     = false
}

# vSphere Infrastructure Variables
variable "datacenter" {
  description = "vSphere datacenter"
  type        = string
}

variable "datastore" {
  description = "vSphere datastore"
  type        = string
}

variable "cluster" {
  description = "vSphere cluster"
  type        = string
}

variable "network_name" {
  description = "Network name to connect VMs"
  type        = string
}

variable "vm_folder1" {
  description = "Windows VM folder name"
  type        = string
  default     = ""
}

variable "vm_folder2" {
 description = "Linux VM folder name"
 type	= string
 default	= ""
}

# Template Variables
variable "windows_template" {
  description = "Name of the Windows VM template"
  type        = string
}

variable "linux_template" {
  description = "Name of the Linux VM template"
  type        = string
}

# Windows VM Variables
variable "windows_vm_count" {
  description = "Number of Windows VMs to create"
  type        = number
  default     = 1
}

variable "windows_vm_prefix" {
  description = "Prefix for Windows VM names"
  type        = string
  default     = "winsrv"
}

variable "windows_vm_cpu" {
  description = "Number of CPUs for Windows VMs"
  type        = number
  default     = 4
}

variable "windows_vm_memory" {
  description = "Memory in MB for Windows VMs"
  type        = number
  default     = 8192
}

variable "windows_vm_disk_size" {
  description = "Disk size in GB for Windows VMs"
  type        = number
  default     = 90
}

variable "windows_admin_password" {
  description = "Administrator password for Windows VMs"
  type        = string
  sensitive   = true
}

variable "windows_timezone" {
  description = "Timezone for Windows VMs"
  type        = string
  default     = "035"  # Eastern Time (US and Canada)
}

variable "windows_run_once_commands" {
  description = "Commands to run once on Windows VM startup"
  type        = list(string)
  default     = []
}

variable "windows_vm_ips" {
  description = "Static IP addresses for Windows VMs"
  type        = list(string)
  default     = []
}

# Linux VM Variables
variable "linux_vm_count" {
  description = "Number of Linux VMs to create"
  type        = number
  default     = 1
}

variable "linux_vm_prefix" {
  description = "Prefix for Linux VM names"
  type        = string
  default     = "lnxsrv"
}

variable "linux_vm_cpu" {
  description = "Number of CPUs for Linux VMs"
  type        = number
  default     = 2
}

variable "linux_vm_memory" {
  description = "Memory in MB for Ubuntu VMs"
  type        = number
  default     = 8192
}

variable "linux_vm_disk_size" {
  description = "Disk size in GB for Linux VMs"
  type        = number
  default     = 30
}

variable "linux_vm_ips" {
  description = "Static IP addresses for Linux VMs"
  type        = list(string)
  default     = []
}

# Network Variables
variable "ipv4_netmask" {
  description = "IPv4 netmask length"
  type        = number
  default     = 24
}

variable "ipv4_gateway" {
  description = "IPv4 gateway"
  type        = string
}

variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = ["192.168.1.1", "8.8.8.8"]
}

variable "domain_name" {
  description = "Domain name for Linux VMs"
  type        = string
  default     = "local"
}

# Environment and Tagging Variables
variable "environment_tag" {
  description = "Environment tag for VMs"
  type        = string
  default     = "Development"
}
