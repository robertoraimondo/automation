# Mixed OS Virtual Machines on vSphere with Terraform

**Author:** Roberto Raimondo - IS Senior Systems Engineer II - CCOE IA AIDE

This Terraform configuration deploys mixed virtual machines (Windows Server and Linux) on VMware vSphere infrastructure

## Prerequisites

1. **Terraform** installed (version >= 1.0)
2. **VMware vSphere** environment with:
   - vCenter Server
   - VM templates for Windows Server, and Linux
   - Appropriate permissions to create VMs
3. **Network connectivity** from your Terraform execution environment to vCenter

## Features

- **Mixed Operating Systems**: Deploy Windows Server, and Linux VMs
- **Flexible Configuration**: Customizable VM specifications (CPU, memory, disk)
- **Network Customization**: Static IP assignment and network configuration
- **VM Tagging**: Automatic tagging for organization and management
- **Scalable**: Configure the number of VMs for each OS type
- **Guest OS Customization**: Automated hostname, network, and domain configuration

## File Structure

```
.
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output definitions
├── terraform.tfvars.example   # Example variables file
└── README.md                  # This file
```

## Configuration

### 1. Create Variables File

Copy the example variables file and customize it for your environment:

```powershell
cp terraform.tfvars.example terraform.tfvars
```

### 2. Update terraform.tfvars

Edit `terraform.tfvars` with your vSphere environment details:

```hcl
# vSphere Connection
vsphere_user     = "administrator@vsphere.local"
vsphere_password = "your-password"
vsphere_server   = "vcenter.yourdomain.com"

# Infrastructure
datacenter   = "Your-Datacenter"
datastore    = "Your-Datastore"
cluster      = "Your-Cluster"
network_name = "VM Network"

# Templates (must exist in vCenter)
windows_template = "Windows Server 2019 Template"
linux_template  = "Linux Template"
```

## VM Templates Requirements

Ensure you have the following VM templates in your vCenter:

### Windows Template
- **OS**: Windows Server 2016/2019/2022
- **VMware Tools**: Installed and running
- **Sysprep**: Template should be sysprepped
- **Administrator account**: Enabled

### Linux Template
- **OS**: Almalinux
- **VMware Tools**: open-vm-tools installed
- **SSH**: Enabled for remote access
- **Cloud-init**: Recommended for customization

## Usage

### 1. Initialize Terraform

```powershell
terraform init
```

### 2. Plan the Deployment

```powershell
terraform plan
```

### 3. Deploy the Infrastructure

```powershell
terraform apply
```

### 4. View Outputs

```powershell
terraform output
```

## Configuration Options

### VM Counts
- `windows_vm_count`: Number of Windows VMs (default: 1)
- `linux_vm_count`: Number of Linux VMs (default: 1)

### VM Specifications
- **CPU**: Configurable per OS type
- **Memory**: Configurable in MB per OS type
- **Disk**: Configurable in GB per OS type

### Network Configuration
- **Static IPs**: Optional static IP assignment
- **DNS**: Configurable DNS servers
- **Gateway**: Network gateway configuration
- **Domain**: Domain name for Linux VMs

### Example Mixed Deployment

```hcl
# Deploy 2 Windows and 3 Linux VM
windows_vm_count = 2
linux_vm_count  = 3

# Different specifications per OS
windows_vm_cpu    = 4
windows_vm_memory = 8192
linux_vm_cpu     = 2
linux_vm_memory  = 4096
```

## Outputs

After deployment, Terraform provides:

- **VM Names**: Names of all created VMs
- **IP Addresses**: IP addresses of all VMs
- **UUIDs**: Unique identifiers for all VMs
- **Summary**: Combined summary of all VM information

## Customization

### Windows Customization
- Administrator password
- Computer name
- Timezone
- Run-once commands
- Domain join (can be extended)

### Linux Customization
- Hostname
- Domain name
- Network configuration
- SSH keys (can be extended)

## Best Practices

1. **Security**:
   - Use strong passwords
   - Store sensitive variables securely
   - Enable SSL certificate verification in production

2. **Resource Management**:
   - Monitor vSphere resource usage
   - Implement proper VM naming conventions
   - Use tags for organization

3. **Backup**:
   - Backup Terraform state files
   - Document template requirements
   - Test recovery procedures

## Troubleshooting

### Common Issues

1. **Template Not Found**:
   - Verify template names in vCenter
   - Check datacenter path

2. **Network Issues**:
   - Verify network names
   - Check IP address ranges
   - Ensure DHCP or static IP configuration

3. **Permission Issues**:
   - Verify vSphere user permissions
   - Check resource pool access
   - Ensure datastore permissions

### Validation Commands

```powershell
# Validate configuration
terraform validate

# Format code
terraform fmt

# Show current state
terraform show

# List resources
terraform state list
```

## Cleanup

To destroy all created resources:

```powershell
terraform destroy
```

## Advanced Features

### Extending the Configuration

You can extend this configuration to include:
- Additional OS types (SUSE, Red Hat, etc.)
- Multiple networks
- Load balancers
- Storage configuration
- Snapshot management
- VM groups and DRS rules

### Integration with Other Tools
- **Ansible**: For post-deployment configuration
- **Packer**: For automated template creation
- **Consul**: For service discovery
- **Vault**: For secrets management

## Support

For issues and questions:
1. Check Terraform vSphere provider documentation
2. Review vSphere logs
3. Validate network connectivity

4. Verify template configurations


