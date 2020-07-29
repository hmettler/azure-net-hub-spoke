terraform {
  required_version  = "~> 0.12.0"
}

provider "azurerm" {
  version         = "=2.0.0"
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}

# Use existing resource group
data "azurerm_resource_group" "rg" {
  name  = var.rg
}

# Create virtual networks
resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnets

  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = each.value.location

  address_space       = each.value.address_space
}

# Create subnets
resource "azurerm_subnet" "subnet" {
  for_each              =var.subnets

  name                  = each.value.name
  resource_group_name   = data.azurerm_resource_group.rg.name

  virtual_network_name  = azurerm_virtual_network.vnet[each.value.link_vnet].name
  address_prefix        = each.value.address_prefix
}

# Create public IPs for virtual network gateways and firwalls
resource "azurerm_public_ip" "public_ip" {
  for_each            = var.public_ips

  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = each.value.location

  sku                 = each.value.sku
  allocation_method   = each.value.allocation_method
}

# Create virtual network gateways
resource "azurerm_virtual_network_gateway" "vnet_gw" {
  for_each            = var.vnet_gws

  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = each.value.location

  type                = each.value.type
  vpn_type            = each.value.vpn_type

  active_active       = each.value.active_active
  enable_bgp          = each.value.enable_bgp
  sku                 = each.value.sku
  generation          = each.value.generation

  ip_configuration {
    name                          = "${each.key}-conf"
    subnet_id                     = azurerm_subnet.subnet[each.value.link_subnet].id
    public_ip_address_id          = azurerm_public_ip.public_ip[each.value.link_ips[0]].id
    private_ip_address_allocation = "Dynamic"
  }

  bgp_settings {
    asn                           = each.value.asn
  }
}

# Create firewall
resource "azurerm_firewall" "firewall" {
  for_each            = var.fws

  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = each.value.location

  ip_configuration {
    name                 = "${each.key}-conf"
    subnet_id            = azurerm_subnet.subnet[each.value.link_subnet].id
    public_ip_address_id = azurerm_public_ip.public_ip[each.value.link_ips[0]].id
  }
}

# Create VNet GW connections
resource "azurerm_virtual_network_gateway_connection" "connection" {
  for_each                        = var.connections

  name                            = each.key
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = each.value.location

  type                            = each.value.type
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vnet_gw[each.value.link_gw1].id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.vnet_gw[each.value.link_gw2].id

  routing_weight                  = each.value.routing_weight
  enable_bgp                      = each.value.enable_bgp
  shared_key                      = each.value.shared_key
}

# Create VNet peerings
resource "azurerm_virtual_network_peering" "peering" {
  for_each                  = var.vnet_peerings

  name                      = each.key
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet[each.value.link_vnet1].name
  remote_virtual_network_id = azurerm_virtual_network.vnet[each.value.link_vnet2].id

  allow_virtual_network_access  = each.value.allow_virtual_network_access
  allow_forwarded_traffic       = each.value.allow_forwarded_traffic
  allow_gateway_transit         = each.value.allow_gateway_transit
  use_remote_gateways           = each.value.use_remote_gateways

}

# Create routing table
resource "azurerm_route_table" "rt" {
  for_each                      = var.rts

  name                          = each.key
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = each.value.location

  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation
}

resource "azurerm_route" "route" {
  for_each                = var.routes

  name                    = each.key
  resource_group_name     = data.azurerm_resource_group.rg.name

  route_table_name        = each.value.link_rt
  address_prefix          = each.value.address_prefix
  next_hop_type           = each.value.next_hop_type
  next_hop_in_ip_address  = each.value.link_next_hop_in_ip_address == null || length(regexall("^\\d{1,3}.\\d{1,3}.\\d{1,3}.\\d{1,3}$", "${each.value.link_next_hop_in_ip_address == null ? "null" : each.value.link_next_hop_in_ip_address}")) > 0 ? each.value.link_next_hop_in_ip_address : azurerm_firewall.firewall[each.value.link_next_hop_in_ip_address].ip_configuration[0].private_ip_address
#  next_hop_in_ip_address  = each.value.link_next_hop_in_ip_address == null || length(regexall("^\\d{1,3}.\\d{1,3}.\\d{1,3}.\\d{1,3}$", "${each.value.link_next_hop_in_ip_address == null ? "null" : each.value.link_next_hop_in_ip_address}")) > 0 ? each.value.link_next_hop_in_ip_address : "0.0.0.0"
}

locals {
  sub_rt_tmp  = [
              for rt_name, rt_data in var.rts: {
                for subnet in rt_data.link_subnets:
                  subnet => rt_name
              }
  ]
  sub_rt  = {
            for item in local.sub_rt_tmp:
              keys(item)[0] => values(item)[0]
  }
}

resource "azurerm_subnet_route_table_association" "sub_rt_ass" {
  for_each        = local.sub_rt

  subnet_id       = azurerm_subnet.subnet[each.key].id
  route_table_id  = azurerm_route_table.rt[each.value].id
}

# Create network firewall rules
resource "azurerm_firewall_network_rule_collection" "fwnrc" {
  for_each            = var.fw_net_rule_colls

  name                = each.key
  azure_firewall_name = each.value.link_fw
  resource_group_name = data.azurerm_resource_group.rg.name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each  = each.value.rules

    content {
      name                  = rule.key
      description           = rule.value.description
      source_addresses      = rule.value.source_addresses
      destination_addresses = rule.value.destination_addresses
      protocols             = rule.value.protocols
      destination_ports     = rule.value.destination_ports
    }
  }
}

# Create application firewall rules
resource "azurerm_firewall_application_rule_collection" "fwarc" {
  for_each            = var.fw_app_rule_colls

  name                = each.key
  azure_firewall_name = each.value.link_fw
  resource_group_name = data.azurerm_resource_group.rg.name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each  = each.value.rules

    content {
      name                  = rule.key
      description           = rule.value.description
      source_addresses      = rule.value.source_addresses
      target_fqdns          = rule.value.target_fqdns
      fqdn_tags             = rule.value.fqdn_tags
      dynamic "protocol" {
        for_each            = rule.value.protocols
        
          content {
            port            = protocol.value.port
            type            = protocol.value.type
          }
      }
    }
  }
}

resource "azurerm_network_security_group" "nsg" {
for_each              = var.nsgs

  name                = each.key
  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each                    = each.value.security_rules

    content {
      name                        = security_rule.key
      description                 = security_rule.value.description
      priority                    = security_rule.value.priority
      direction                   = security_rule.value.direction
      access                      = security_rule.value.access
      source_address_prefix       = security_rule.value.source_address_prefix
      destination_address_prefix  = security_rule.value.destination_address_prefix
      protocol                    = security_rule.value.protocol
      source_port_range           = security_rule.value.source_port_range
      destination_port_range      = security_rule.value.destination_port_range
      source_port_ranges          = security_rule.value.source_port_ranges
      destination_port_ranges     = security_rule.value.destination_port_ranges
    }
  }
}

locals {
  sub_nsg_tmp  = [
              for nsg_name, nsg_data in var.nsgs: {
                for subnet in nsg_data.link_subnets:
                  subnet => nsg_name
              }
  ]
  sub_nsg  = {
            for item in local.sub_nsg_tmp:
              keys(item)[0] => values(item)[0]
  }
}

resource "azurerm_subnet_network_security_group_association" "sub_nsg_ass" {
  for_each                  = local.sub_nsg

  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.value].id
}


# Build some VMs to test connectivity
# Used https://registry.terraform.io/modules/Azure/compute/azurerm/3.3.0
module "linuxservers1" {
#  for_each            = var.vms                        -> Should be available with Terraform 0.13

  source              = "Azure/compute/azurerm"
  version             = "=3.3.0"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.vm1.location

  vm_hostname         = var.vm1.name
  vm_os_simple        = "CentOS"
  vm_size             = var.vm1.vm_size
  vnet_subnet_id      = azurerm_subnet.subnet[var.vm1.link_subnet].id
  nb_public_ip        = var.vm1.nb_public_ip

  enable_ssh_key      = false
  admin_username      = var.vm1.admin_username
  admin_password      = var.vm1.admin_password
  delete_os_disk_on_termination = true
}

module "linuxservers2" {
#  for_each            = var.vms                        -> Should be available with Terraform 0.13

  source              = "Azure/compute/azurerm"
  version             = "=3.3.0"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.vm2.location

  vm_hostname         = var.vm2.name
  vm_os_simple        = "CentOS"
  vm_size             = var.vm2.vm_size
  vnet_subnet_id      = azurerm_subnet.subnet[var.vm2.link_subnet].id
  nb_public_ip        = var.vm2.nb_public_ip

  enable_ssh_key      = false
  admin_username      = var.vm2.admin_username
  admin_password      = var.vm2.admin_password
  delete_os_disk_on_termination = true
}

module "linuxservers3" {
#  for_each            = var.vms                        -> Should be available with Terraform 0.13

  source              = "Azure/compute/azurerm"
  version             = "=3.3.0"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.vm3.location

  vm_hostname         = var.vm3.name
  vm_os_simple        = "CentOS"
  vm_size             = var.vm3.vm_size
  vnet_subnet_id      = azurerm_subnet.subnet[var.vm3.link_subnet].id
  nb_public_ip        = var.vm3.nb_public_ip

  enable_ssh_key      = false
  admin_username      = var.vm3.admin_username
  admin_password      = var.vm3.admin_password
  delete_os_disk_on_termination = true
}

module "linuxservers4" {
#  for_each            = var.vms                        -> Should be available with Terraform 0.13

  source              = "Azure/compute/azurerm"
  version             = "=3.3.0"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.vm4.location

  vm_hostname         = var.vm4.name
  vm_os_simple        = "CentOS"
  vm_size             = var.vm4.vm_size
  vnet_subnet_id      = azurerm_subnet.subnet[var.vm4.link_subnet].id
  nb_public_ip        = var.vm4.nb_public_ip

  enable_ssh_key      = false
  admin_username      = var.vm4.admin_username
  admin_password      = var.vm4.admin_password
  delete_os_disk_on_termination = true
}

module "linuxservers5" {
#  for_each            = var.vms                        -> Should be available with Terraform 0.13

  source              = "Azure/compute/azurerm"
  version             = "=3.3.0"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.vm5.location

  vm_hostname         = var.vm5.name
  vm_os_simple        = "CentOS"
  vm_size             = var.vm5.vm_size
  vnet_subnet_id      = azurerm_subnet.subnet[var.vm5.link_subnet].id
  nb_public_ip        = var.vm5.nb_public_ip

  enable_ssh_key      = false
  admin_username      = var.vm5.admin_username
  admin_password      = var.vm5.admin_password
  delete_os_disk_on_termination = true
}

module "linuxservers6" {
#  for_each            = var.vms                        -> Should be available with Terraform 0.13

  source              = "Azure/compute/azurerm"
  version             = "=3.3.0"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.vm6.location

  vm_hostname         = var.vm6.name
  vm_os_simple        = "CentOS"
  vm_size             = var.vm6.vm_size
  vnet_subnet_id      = azurerm_subnet.subnet[var.vm6.link_subnet].id
  nb_public_ip        = var.vm6.nb_public_ip

  enable_ssh_key      = false
  admin_username      = var.vm6.admin_username
  admin_password      = var.vm6.admin_password
  delete_os_disk_on_termination = true
}
