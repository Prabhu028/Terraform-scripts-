variable "location" {
  type        = string
  default     = "Eastus"
  description = "This is resources location"
}
variable "resource_name" {
  type        = string
  default     = "MH"
  description = "This is resource name"
}
variable "vnet_name" {
  type        = string
  default     = "MH_vnet"
  description = "This is mhvnet name"
}
variable "vnet_cidr" {
  default     = "10.0.0.0/16"
  description = "this is vnet address space"
}
variable "subnet_name" {
  type        = string
  default     = "appsubnet"
  description = "this is subnet names"
}
variable "subnet_cidr" {
  type        = string
  default     = "10.1.0.0/24"
  description = "this is subnet cidr"
}
variable "nsg_rules_app_subnet" {
  type = list(object({
    name                       = string
    description                = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
    access                     = string
    priority                   = number
  }))
  description = "webapp nsg rules"
  default = [{
    name                       = "openssh"
    description                = "this opens 22 port"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 1000
  }]
}

variable "vm_name" {
  type        = string
  default     = "Mh_vm"
  description = "Vm name"
}
variable "admin_username" {
  type        = string
  default     = "Ubuntu"
  description = "this is username of vm"
}
# variable "Admin_password" {
#   type = string
#   default = "string"
#   sensitive = true
# }
variable "vm_size" {
  type    = string
  default = "Standard_b1s"

}
variable "db_name" {
  type    = string
  default = "dev-postgresql-flexiblemh"
}
