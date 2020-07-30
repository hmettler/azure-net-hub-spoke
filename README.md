# Azure Network Setup
Can be used to create Azure network setups.
Azure Virtual WAN and Virtual Hub might in the meantime be a better solution.

Uses Terraform to provision Azure VPN Gateway, Azure Firewall and Hub and Spoke VNets and many more.

## Installation
1. Download Terraform: https://www.terraform.io/downloads.html
2. Configure Azure Provider for Terraform: https://www.terraform.io/docs/providers/azurerm/index.html
3. Clone repository: https://github.com/hmettler/azure-net-hub-spoke.git

## Usage
1. Adapt terraform.tfvars as needed
2. `terraform init`
3. `terraform plan`
4. `terraform apply`

To delete resources in Azure
1. `terraform destroy`

## Support
No support is provided.

## License
