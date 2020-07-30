rg = "rg-hpm-03"

# Local is a replacement for an onprem network and is used for VPN gateway and workplace subnets
# Hub is used for VPN gateway, firewall and mgmt and services subnets (currently one svc subnet is created only)
# DMZ is used for DMZ subnets (currently an internal and external subnet is created to host dual-homed GWs)
vnets = {
          vnet-local-euw        = {location = "West Europe", address_space = ["10.0.0.0/16"]},

          vnet-local-eun        = {location = "North Europe", address_space = ["10.1.0.0/16"]},

          vnet-az-euw-hub       = {location = "West Europe", address_space = ["10.100.0.0/21"]},
          vnet-az-euw-prod-dmz  = {location = "West Europe", address_space = ["10.100.8.0/21"]},
          vnet-az-euw-prod-app  = {location = "West Europe", address_space = ["10.100.16.0/21"]},
          vnet-az-euw-prod-db   = {location = "West Europe", address_space = ["10.100.24.0/21"]},

          vnet-az-eun-hub       = {location = "North Europe", address_space = ["10.101.0.0/21"]},
          vnet-az-eun-prod-dmz  = {location = "North Europe", address_space = ["10.101.8.0/21"]},
          vnet-az-eun-prod-app  = {location = "North Europe", address_space = ["10.101.16.0/21"]},
          vnet-az-eun-prod-db   = {location = "North Europe", address_space = ["10.101.24.0/21"]},

}

subnets = {
            snet-local-euw-gateway    = {name = "GatewaySubnet", link_vnet = "vnet-local-euw", address_prefix = "10.0.0.0/24"},
            snet-local-euw-workplace  = {name = "snet-local-euw-workplace", link_vnet = "vnet-local-euw", address_prefix = "10.0.1.0/24"},

            snet-local-eun-gateway    = {name = "GatewaySubnet", link_vnet = "vnet-local-eun", address_prefix = "10.1.0.0/24"},
            snet-local-eun-workplace  = {name = "snet-local-eun-workplace", link_vnet = "vnet-local-eun", address_prefix = "10.1.1.0/24"},

            snet-az-euw-hub-gateway   = {name = "GatewaySubnet", link_vnet = "vnet-az-euw-hub", address_prefix = "10.100.0.0/24"},
            snet-az-euw-hub-firewall  = {name = "AzureFirewallSubnet", link_vnet = "vnet-az-euw-hub", address_prefix = "10.100.1.0/24"},
            snet-az-euw-hub-svc1      = {name = "snet-az-euw-hub-svc1", link_vnet = "vnet-az-euw-hub", address_prefix = "10.100.2.0/24"},
            snet-az-euw-prod-dmz1     = {name = "snet-az-euw-prod-dmz1", link_vnet = "vnet-az-euw-prod-dmz", address_prefix = "10.100.8.0/24"},
            snet-az-euw-prod-dmz2     = {name = "snet-az-euw-prod-dmz2", link_vnet = "vnet-az-euw-prod-dmz", address_prefix = "10.100.9.0/24"},
            snet-az-euw-prod-app1     = {name = "snet-az-euw-prod-app1", link_vnet = "vnet-az-euw-prod-app", address_prefix = "10.100.16.0/24"},
            snet-az-euw-prod-db1      = {name = "snet-az-euw-prod-db1", link_vnet = "vnet-az-euw-prod-db", address_prefix = "10.100.24.0/24"},

            snet-az-eun-hub-gateway   = {name = "GatewaySubnet", link_vnet = "vnet-az-eun-hub", address_prefix = "10.101.0.0/24"},
            snet-az-eun-hub-firewall  = {name = "AzureFirewallSubnet", link_vnet = "vnet-az-eun-hub", address_prefix = "10.101.1.0/24"},
            snet-az-eun-hub-svc1      = {name = "snet-az-eun-hub-svc1", link_vnet = "vnet-az-eun-hub", address_prefix = "10.101.2.0/24"},
            snet-az-eun-prod-dmz1     = {name = "snet-az-eun-prod-dmz1", link_vnet = "vnet-az-eun-prod-dmz", address_prefix = "10.101.8.0/24"},
            snet-az-eun-prod-dmz2     = {name = "snet-az-eun-prod-dmz2", link_vnet = "vnet-az-eun-prod-dmz", address_prefix = "10.101.9.0/24"},
            snet-az-eun-prod-app1     = {name = "snet-az-eun-prod-app1", link_vnet = "vnet-az-eun-prod-app", address_prefix = "10.101.16.0/24"},
            snet-az-eun-prod-db1      = {name = "snet-az-eun-prod-db1", link_vnet = "vnet-az-eun-prod-db", address_prefix = "10.101.24.0/24"},
}

public_ips  = {
                pip-vnetgw-local-euw  = {location = "West Europe", sku = "Basic", allocation_method = "Dynamic"},

#                pip-vnetgw-local-eun  = {location = "North Europe", sku = "Basic", allocation_method = "Dynamic"},

                pip-vnetgw-az-euw-hub = {location = "West Europe", sku = "Basic", allocation_method = "Dynamic"},
                pip-fw-az-euw-hub     = {location = "West Europe", sku = "Standard", allocation_method = "Static"},

#                pip-vnetgw-az-eun-hub = {location = "North Europe", sku = "Basic", allocation_method = "Dynamic"},
}

vnet_gws  = {
              vnetgw-local-euw  = {location = "West Europe", link_subnet = "snet-local-euw-gateway", type = "Vpn", vpn_type = "RouteBased", active_active = false, enable_bgp = true, sku = "VpnGw1", generation = "Generation1", link_ips = ["pip-vnetgw-local-euw"], asn = 64512},

#              vnetgw-local-eun  = {location = "North Europe", link_subnet = "snet-local-eun-gateway", type = "Vpn", vpn_type = "RouteBased", active_active = false, enable_bgp = true, sku = "VpnGw1", generation = "Generation1", link_ips = ["pip-vnetgw-local-eun"], asn = 64513},

              vnetgw-az-euw-hub = {location = "West Europe", link_subnet = "snet-az-euw-hub-gateway", type = "Vpn", vpn_type = "RouteBased", active_active = false, enable_bgp = true, sku = "VpnGw1", generation = "Generation1", link_ips = ["pip-vnetgw-az-euw-hub"], asn = 64514},

#              vnetgw-az-eun-hub = {location = "North Europe", link_subnet = "snet-az-eun-hub-gateway", type = "Vpn", vpn_type = "RouteBased", active_active = false, enable_bgp = true, sku = "VpnGw1", generation = "Generation1", link_ips = ["pip-vnetgw-az-eun-hub"], asn = 64515},
}

fws = {
        fw-az-euw-hub = {location = "West Europe", link_subnet = "snet-az-euw-hub-firewall", link_ips = ["pip-fw-az-euw-hub"]},
}

# Remark: Remove key from file for a real world deployment!
connections = {
/*
                conn-az-euw-hub-az-eun-hub = {location = "West Europe", type = "Vnet2Vnet", shared_key = "Secret_Shared_Key", link_gw1 = "vnetgw-az-euw-hub", link_gw2 = "vnetgw-az-eun-hub", enable_bgp = true, routing_weight = 10},
                conn-az-eun-hub-az-euw-hub = {location = "North Europe", type = "Vnet2Vnet", shared_key = "Secret_Shared_Key", link_gw1 = "vnetgw-az-eun-hub", link_gw2 = "vnetgw-az-euw-hub", enable_bgp = true, routing_weight = 10},
*/
                conn-local-euw-az-euw-hub = {location = "West Europe", type = "Vnet2Vnet", shared_key = "Secret_Shared_Key", link_gw1 = "vnetgw-local-euw", link_gw2 = "vnetgw-az-euw-hub", enable_bgp = true, routing_weight = 10},
                conn-az-euw-hub-local-euw = {location = "West Europe", type = "Vnet2Vnet", shared_key = "Secret_Shared_Key", link_gw1 = "vnetgw-az-euw-hub", link_gw2 = "vnetgw-local-euw", enable_bgp = true, routing_weight = 10},
/*
                conn-local-eun-az-eun-hub = {location = "North Europe", type = "Vnet2Vnet", shared_key = "Secret_Shared_Key", link_gw1 = "vnetgw-local-eun", link_gw2 = "vnetgw-az-eun-hub", enable_bgp = true, routing_weight = 10},
                conn-az-eun-hub-local-eun = {location = "North Europe", type = "Vnet2Vnet", shared_key = "Secret_Shared_Key", link_gw1 = "vnetgw-az-eun-hub", link_gw2 = "vnetgw-local-eun", enable_bgp = true, routing_weight = 10},

                conn-local-euw-az-eun-hub = {location = "West Europe", type = "Vnet2Vnet", shared_key = "Secret_Shared_Key", link_gw1 = "vnetgw-local-euw", link_gw2 = "vnetgw-az-eun-hub", enable_bgp = true, routing_weight = 10},
                conn-az-eun-hub-local-euw = {location = "North Europe", type = "Vnet2Vnet", shared_key = "Secret_Shared_Key", link_gw1 = "vnetgw-az-eun-hub", link_gw2 = "vnetgw-local-euw", enable_bgp = true, routing_weight = 10},

                conn-local-eun-az-euw-hub = {location = "North Europe", type = "Vnet2Vnet", shared_key = "Secret_Shared_Key", link_gw1 = "vnetgw-local-eun", link_gw2 = "vnetgw-az-euw-hub", enable_bgp = true, routing_weight = 10},
                conn-az-euw-hub-local-eun = {location = "West Europe", type = "Vnet2Vnet", shared_key = "Secret_Shared_Key", link_gw1 = "vnetgw-az-euw-hub", link_gw2 = "vnetgw-local-eun", enable_bgp = true, routing_weight = 10},
*/
}

vnet_peerings = {
/*
                  peering-az-euw-hub-az-eun-hub       = {link_vnet1 = "vnet-az-euw-hub", link_vnet2 = "vnet-az-eun-hub", allow_virtual_network_access = true, allow_forwarded_traffic = true, allow_gateway_transit = false, use_remote_gateways = false},
                  peering-az-eun-hub-az-euw-hub       = {link_vnet1 = "vnet-az-eun-hub", link_vnet2 = "vnet-az-euw-hub", allow_virtual_network_access = true, allow_forwarded_traffic = true, allow_gateway_transit = false, use_remote_gateways = false},
*/
# With Firewall
                  peering-az-euw-hub-az-euw-prod-dmz  = {link_vnet1 = "vnet-az-euw-hub", link_vnet2 = "vnet-az-euw-prod-dmz", allow_virtual_network_access = true, allow_forwarded_traffic = true, allow_gateway_transit = true, use_remote_gateways = false},
                  peering-az-euw-prod-dmz-az-euw-hub  = {link_vnet1 = "vnet-az-euw-prod-dmz", link_vnet2 = "vnet-az-euw-hub", allow_virtual_network_access = true, allow_forwarded_traffic = false, allow_gateway_transit = false, use_remote_gateways = true},
                  peering-az-euw-hub-az-euw-prod-app  = {link_vnet1 = "vnet-az-euw-hub", link_vnet2 = "vnet-az-euw-prod-app", allow_virtual_network_access = true, allow_forwarded_traffic = true, allow_gateway_transit = true, use_remote_gateways = false},
                  peering-az-euw-prod-app-az-euw-hub  = {link_vnet1 = "vnet-az-euw-prod-app", link_vnet2 = "vnet-az-euw-hub", allow_virtual_network_access = true, allow_forwarded_traffic = false, allow_gateway_transit = false, use_remote_gateways = true},
                  peering-az-euw-hub-az-euw-prod-db   = {link_vnet1 = "vnet-az-euw-hub", link_vnet2 = "vnet-az-euw-prod-db", allow_virtual_network_access = true, allow_forwarded_traffic = true, allow_gateway_transit = true, use_remote_gateways = false},
                  peering-az-euw-prod-db-az-euw-hub   = {link_vnet1 = "vnet-az-euw-prod-db", link_vnet2 = "vnet-az-euw-hub", allow_virtual_network_access = true, allow_forwarded_traffic = false, allow_gateway_transit = false, use_remote_gateways = true},

# Without Firewall
/*
                  peering-az-eun-hub-az-eun-prod-dmz  = {link_vnet1 = "vnet-az-eun-hub", link_vnet2 = "vnet-az-eun-prod-dmz", allow_virtual_network_access = true, allow_forwarded_traffic = true, allow_gateway_transit = true, use_remote_gateways = false},
                  peering-az-eun-prod-dmz-az-eun-hub  = {link_vnet1 = "vnet-az-eun-prod-dmz", link_vnet2 = "vnet-az-eun-hub", allow_virtual_network_access = true, allow_forwarded_traffic = false, allow_gateway_transit = false, use_remote_gateways = true},
                  peering-az-eun-hub-az-eun-prod-app  = {link_vnet1 = "vnet-az-eun-hub", link_vnet2 = "vnet-az-eun-prod-app", allow_virtual_network_access = true, allow_forwarded_traffic = true, allow_gateway_transit = true, use_remote_gateways = false},
                  peering-az-eun-prod-app-az-eun-hub  = {link_vnet1 = "vnet-az-eun-prod-app", link_vnet2 = "vnet-az-eun-hub", allow_virtual_network_access = true, allow_forwarded_traffic = false, allow_gateway_transit = false, use_remote_gateways = true},
                  peering-az-eun-hub-az-eun-prod-db   = {link_vnet1 = "vnet-az-eun-hub", link_vnet2 = "vnet-az-eun-prod-db", allow_virtual_network_access = true, allow_forwarded_traffic = true, allow_gateway_transit = true, use_remote_gateways = false},
                  peering-az-eun-prod-db-az-eun-hub   = {link_vnet1 = "vnet-az-eun-prod-db", link_vnet2 = "vnet-az-eun-hub", allow_virtual_network_access = true, allow_forwarded_traffic = false, allow_gateway_transit = false, use_remote_gateways = true},
*/
}

rts = {
# With Firewall
        rt-snet-az-euw-hub-gateway  = {location = "West Europe", disable_bgp_route_propagation = true, link_subnets = ["snet-az-euw-hub-gateway"]},
        rt-snet-az-euw-hub-svc1     = {location = "West Europe", disable_bgp_route_propagation = true, link_subnets = ["snet-az-euw-hub-svc1"]},
        rt-snet-az-euw-prod-dmz1    = {location = "West Europe", disable_bgp_route_propagation = true, link_subnets = ["snet-az-euw-prod-dmz1"]},
        rt-snet-az-euw-prod-dmz2    = {location = "West Europe", disable_bgp_route_propagation = true, link_subnets = ["snet-az-euw-prod-dmz2"]},
        rt-vnet-az-euw-prod-app     = {location = "West Europe", disable_bgp_route_propagation = true, link_subnets = ["snet-az-euw-prod-app1"]},
        rt-vnet-az-euw-prod-db      = {location = "West Europe", disable_bgp_route_propagation = true, link_subnets = ["snet-az-euw-prod-db1"]},

# Without Firewall
/*
        rt-snet-az-eun-prod-dmz1    = {location = "North Europe", disable_bgp_route_propagation = false, link_subnets = ["snet-az-eun-prod-dmz1"]},
        rt-snet-az-eun-prod-dmz2    = {location = "North Europe", disable_bgp_route_propagation = true, link_subnets = ["snet-az-eun-prod-dmz2"]},
        rt-vnet-az-eun-prod-app     = {location = "North Europe", disable_bgp_route_propagation = false, link_subnets = ["snet-az-eun-prod-app1"]},
        rt-vnet-az-eun-prod-db      = {location = "North Europe", disable_bgp_route_propagation = false, link_subnets = ["snet-az-eun-prod-db1"]},
*/
}

routes  = {
# With Firewall (default route to None blocks all traffic to Internet)
            route-snet-az-euw-hub-gateway-hub   = {link_rt = "rt-snet-az-euw-hub-gateway", address_prefix = "10.100.0.0/21", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},
            route-snet-az-euw-hub-gateway-dmz   = {link_rt = "rt-snet-az-euw-hub-gateway", address_prefix = "10.100.8.0/21", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},
            route-snet-az-euw-hub-gateway-app   = {link_rt = "rt-snet-az-euw-hub-gateway", address_prefix = "10.100.16.0/21", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},
            route-snet-az-euw-hub-gateway-db    = {link_rt = "rt-snet-az-euw-hub-gateway", address_prefix = "10.100.24.0/21", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},

            route-snet-az-euw-hub-svc1-hub      = {link_rt = "rt-snet-az-euw-hub-svc1", address_prefix = "10.100.0.0/21", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},
            route-snet-az-euw-hub-svc1-dmz      = {link_rt = "rt-snet-az-euw-hub-svc1", address_prefix = "10.100.8.0/21", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},
            route-snet-az-euw-hub-svc1-app      = {link_rt = "rt-snet-az-euw-hub-svc1", address_prefix = "10.100.16.0/21", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},
            route-snet-az-euw-hub-svc1-db       = {link_rt = "rt-snet-az-euw-hub-svc1", address_prefix = "10.100.24.0/21", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},
            route-snet-az-euw-hub-svc1-default  = {link_rt = "rt-snet-az-euw-hub-svc1", address_prefix = "0.0.0.0/0", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},

            route-snet-az-euw-prod-dmz1-hub     = {link_rt = "rt-snet-az-euw-prod-dmz1", address_prefix = "10.100.0.0/21", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},
            route-snet-az-euw-prod-dmz1-dmz1    = {link_rt = "rt-snet-az-euw-prod-dmz1", address_prefix = "10.100.8.0/24", next_hop_type = "VnetLocal", link_next_hop_in_ip_address = null},
            route-snet-az-euw-prod-dmz1-dmz2    = {link_rt = "rt-snet-az-euw-prod-dmz1", address_prefix = "10.100.9.0/24", next_hop_type = "None", link_next_hop_in_ip_address = null},
            route-snet-az-euw-prod-dmz1-dmz     = {link_rt = "rt-snet-az-euw-prod-dmz1", address_prefix = "10.100.8.0/21", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},
            route-snet-az-euw-prod-dmz1-default = {link_rt = "rt-snet-az-euw-prod-dmz1", address_prefix = "0.0.0.0/0", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},

            route-snet-az-euw-prod-dmz2-hub     = {link_rt = "rt-snet-az-euw-prod-dmz2", address_prefix = "10.100.0.0/21", next_hop_type = "None", link_next_hop_in_ip_address = null},
            route-snet-az-euw-prod-dmz2-dmz2    = {link_rt = "rt-snet-az-euw-prod-dmz2", address_prefix = "10.100.9.0/24", next_hop_type = "VnetLocal", link_next_hop_in_ip_address = null},
            route-snet-az-euw-prod-dmz2-dmz     = {link_rt = "rt-snet-az-euw-prod-dmz2", address_prefix = "10.100.8.0/21", next_hop_type = "None", link_next_hop_in_ip_address = null},

            route-vnet-az-euw-prod-app-hub      = {link_rt = "rt-vnet-az-euw-prod-app", address_prefix = "10.100.0.0/21", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},
            route-vnet-az-euw-prod-app-default  = {link_rt = "rt-vnet-az-euw-prod-app", address_prefix = "0.0.0.0/0", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},

            route-vnet-az-euw-prod-db-hub       = {link_rt = "rt-vnet-az-euw-prod-db", address_prefix = "10.100.0.0/21", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},
            route-vnet-az-euw-prod-db-default   = {link_rt = "rt-vnet-az-euw-prod-db", address_prefix = "0.0.0.0/0", next_hop_type = "VirtualAppliance", link_next_hop_in_ip_address = "fw-az-euw-hub"},

# Without Firewall (default route to None blocks all traffic to Internet)
/*
            route-snet-sz-eun-hub-svc1-default  = {link_rt = "rt-snet-az-eun-hub-svc1", address_prefix = "0.0.0.0/0", next_hop_type = "None", link_next_hop_in_ip_address = null},

            route-snet-az-eun-prod-dmz1-dmz2    = {link_rt = "rt-vnet-az-eun-prod-dmz1", address_prefix = "10.101.9.0/24", next_hop_type = "None", link_next_hop_in_ip_address = null},
            route-snet-az-eun-prod-dmz1-default = {link_rt = "rt-vnet-az-eun-prod-dmz1", address_prefix = "0.0.0.0/0", next_hop_type = "None", link_next_hop_in_ip_address = null},

            route-snet-az-eun-prod-dmz2-hub     = {link_rt = "rt-snet-az-eun-prod-dmz2", address_prefix = "10.101.0.0/21", next_hop_type = "None", link_next_hop_in_ip_address = null},
            route-snet-az-eun-prod-dmz2-dmz2    = {link_rt = "rt-vnet-az-eun-prod-dmz2", address_prefix = "10.101.9.0/24", next_hop_type = "VnetLocal", link_next_hop_in_ip_address = null},
            route-snet-az-eun-prod-dmz2-dmz     = {link_rt = "rt-vnet-az-eun-prod-dmz2", address_prefix = "10.101.8.0/21", next_hop_type = "None", link_next_hop_in_ip_address = null},

            route-vnet-az-eun-prod-app-default  = {link_rt = "rt-vnet-az-eun-prod-app", address_prefix = "0.0.0.0/0", next_hop_type = "None", link_next_hop_in_ip_address = null},
            route-vnet-az-eun-prod-db-default   = {link_rt = "rt-vnet-az-eun-prod-db", address_prefix = "0.0.0.0/0", next_hop_type = "None", link_next_hop_in_ip_address = null},
*/
}

fw_net_rule_colls = {
                      fwnrc-fw-az-euw-hub-base = {link_fw = "fw-az-euw-hub", priority = 100, action = "Allow"
                        rules = {
                          ssh = {description = "Allows ssh in all private networks", source_addresses = ["10.0.0.0/8"], destination_addresses = ["10.0.0.0/8"], protocols = ["TCP"], destination_ports = ["22"]}
                        }
                      },
}

fw_app_rule_colls = {
                      fwarc-fw-az-euw-hub-base = {link_fw = "fw-az-euw-hub", priority = 100, action = "Allow"
                        rules = {
                          some-urls = {description = "Allows ssh in all private networks", source_addresses = ["10.0.0.0/8"], target_fqdns = ["www.google.com"], fqdn_tags = [], protocols = [{port = "80", type = "Http"}, {port = "443", type = "Https"}]}
                        }
                      },
}

nsgs  = {
          nsg-snet-az-euw-prod-dmz1  = {location = "West Europe", link_subnets = ["snet-az-euw-prod-dmz1"],
            security_rules = {
              allow-ssh-in  = {description = "Allows ssh to subnet", priority = 100, direction = "Inbound", access = "Allow", source_address_prefix = "10.0.0.0/8", destination_address_prefix = "*", protocol = "Tcp", source_port_range = "*", source_port_ranges = null, destination_port_range = null, destination_port_ranges = ["22"]},
              allow-lb-in   = {description = "Allows LB to subnet", priority = 4080, direction = "Inbound", access = "Allow", source_address_prefix = "AzureLoadBalancer", destination_address_prefix = "*", protocol = "*", source_port_range = "*", source_port_ranges = null, destination_port_range = "*", destination_port_ranges = null},
              deny-all-in   = {description = "Deny all to subnet", priority = 4090, direction = "Inbound", access = "Deny", source_address_prefix = "*", destination_address_prefix = "*", protocol = "*", source_port_range = "*", source_port_ranges = null, destination_port_range = "*", destination_port_ranges = null},
              allow-ssh-out = {description = "Allows ssh out of subnet", priority = 100, direction = "Outbound", access = "Allow", source_address_prefix = "*", destination_address_prefix = "10.0.0.0/8", protocol = "Tcp", source_port_range = "*", source_port_ranges = null, destination_port_range = null, destination_port_ranges = ["22"]}
              deny-all-out  = {description = "Deny all out of subnet", priority = 4090, direction = "Outbound", access = "Deny", source_address_prefix = "*", destination_address_prefix = "*", protocol = "*", source_port_range = "*", source_port_ranges = null, destination_port_range = "*", destination_port_ranges = null}
            }
          },
          nsg-snet-az-euw-prod-dmz2  = {location = "West Europe", link_subnets = ["snet-az-euw-prod-dmz2"],
            security_rules = {
              allow-ssh-in  = {description = "Allows ssh to subnet", priority = 100, direction = "Inbound", access = "Allow", source_address_prefix = "*", destination_address_prefix = "*", protocol = "Tcp", source_port_range = "*", source_port_ranges = null, destination_port_range = null, destination_port_ranges = ["22"]},
              allow-lb-in   = {description = "Allows LB to subnet", priority = 4080, direction = "Inbound", access = "Allow", source_address_prefix = "AzureLoadBalancer", destination_address_prefix = "*", protocol = "*", source_port_range = "*", source_port_ranges = null, destination_port_range = "*", destination_port_ranges = null},
              deny-all-in   = {description = "Deny all to subnet", priority = 4090, direction = "Inbound", access = "Deny", source_address_prefix = "*", destination_address_prefix = "*", protocol = "*", source_port_range = "*", source_port_ranges = null, destination_port_range = "*", destination_port_ranges = null},
              deny-all-out  = {description = "Deny all out of subnet", priority = 4090, direction = "Outbound", access = "Deny", source_address_prefix = "*", destination_address_prefix = "*", protocol = "*", source_port_range = "*", source_port_ranges = null, destination_port_range = "*", destination_port_ranges = null}
            }
          },

          nsg-snet-az-eun-prod-dmz1  = {location = "North Europe", link_subnets = ["snet-az-eun-prod-dmz1"],
            security_rules = {
              allow-ssh-in  = {description = "Allows ssh to subnet", priority = 100, direction = "Inbound", access = "Allow", source_address_prefix = "10.0.0.0/8", destination_address_prefix = "*", protocol = "Tcp", source_port_range = "*", source_port_ranges = null, destination_port_range = null, destination_port_ranges = ["22"]},
              allow-lb-in   = {description = "Allows LB to subnet", priority = 4080, direction = "Inbound", access = "Allow", source_address_prefix = "AzureLoadBalancer", destination_address_prefix = "*", protocol = "*", source_port_range = "*", source_port_ranges = null, destination_port_range = "*", destination_port_ranges = null},
              deny-all-in   = {description = "Deny all to subnet", priority = 4090, direction = "Inbound", access = "Deny", source_address_prefix = "*", destination_address_prefix = "*", protocol = "*", source_port_range = "*", source_port_ranges = null, destination_port_range = "*", destination_port_ranges = null},
              allow-ssh-out = {description = "Allows ssh out of subnet", priority = 100, direction = "Outbound", access = "Allow", source_address_prefix = "*", destination_address_prefix = "10.0.0.0/8", protocol = "Tcp", source_port_range = "*", source_port_ranges = null, destination_port_range = null, destination_port_ranges = ["22"]}
              deny-all-out  = {description = "Deny all out of subnet", priority = 4090, direction = "Outbound", access = "Deny", source_address_prefix = "*", destination_address_prefix = "*", protocol = "*", source_port_range = "*", source_port_ranges = null, destination_port_range = "*", destination_port_ranges = null}
            }
          },
          nsg-snet-az-eun-prod-dmz2  = {location = "North Europe", link_subnets = ["snet-az-eun-prod-dmz2"],
            security_rules = {
              allow-ssh-in  = {description = "Allows ssh to subnet", priority = 100, direction = "Inbound", access = "Allow", source_address_prefix = "*", destination_address_prefix = "*", protocol = "Tcp", source_port_range = "*", source_port_ranges = null, destination_port_range = null, destination_port_ranges = ["22"]},
              allow-lb-in   = {description = "Allows LB to subnet", priority = 4080, direction = "Inbound", access = "Allow", source_address_prefix = "AzureLoadBalancer", destination_address_prefix = "*", protocol = "*", source_port_range = "*", source_port_ranges = null, destination_port_range = "*", destination_port_ranges = null},
              deny-all-in   = {description = "Deny all to subnet", priority = 4090, direction = "Inbound", access = "Deny", source_address_prefix = "*", destination_address_prefix = "*", protocol = "*", source_port_range = "*", source_port_ranges = null, destination_port_range = "*", destination_port_ranges = null},
              deny-all-out  = {description = "Deny all out of subnet", priority = 4090, direction = "Outbound", access = "Deny", source_address_prefix = "*", destination_address_prefix = "*", protocol = "*", source_port_range = "*", source_port_ranges = null, destination_port_range = "*", destination_port_ranges = null}
            }
          },
}

# Remark: Remove (user) and password from file for a real world deployment!
vm1 = {name = "vm-local-euw-workplace", location = "West Europe", vm_size = "Standard_B1ls", link_subnet = "snet-local-euw-workplace", nb_public_ip = "1", admin_username = "admin", admin_password = "Secret_Password"}
vm2 = {name = "vm-az-euw-prod-app1", location = "West Europe", vm_size = "Standard_B1ls", link_subnet = "snet-az-euw-prod-app1", nb_public_ip = "0", admin_username = "admin", admin_password = "Secret_Password"}
vm3 = {name = "vm-az-euw-prod-db1", location = "West Europe", vm_size = "Standard_B1ls", link_subnet = "snet-az-euw-prod-db1", nb_public_ip = "0", admin_username = "admin", admin_password = "Secret_Password"}
vm4 = {name = "vm-az-euw-hub-svc1", location = "West Europe", vm_size = "Standard_B1ls", link_subnet = "snet-az-euw-hub-svc1", nb_public_ip = "0", admin_username = "admin", admin_password = "Secret_Password"}
vm5 = {name = "vm-az-euw-prod-dmz1", location = "West Europe", vm_size = "Standard_B1ls", link_subnet = "snet-az-euw-prod-dmz1", nb_public_ip = "0", admin_username = "admin", admin_password = "Secret_Password"}
vm6 = {name = "vm-az-euw-prod-dmz2", location = "West Europe", vm_size = "Standard_B1ls", link_subnet = "snet-az-euw-prod-dmz2", nb_public_ip = "1", admin_username = "admin", admin_password = "Secret_Password"}