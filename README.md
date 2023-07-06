# TerraformChallengeAzure
Terraform Challenge repository 
# Azure Infrastructure with Terraform

This repository contains Terraform code to provision a scalable infrastructure on Azure, including a virtual network, subnets, Apache servers running on multiple VMs, a load balancer (Azure Application Gateway), and a NAT Gateway. Additionally, an alert system is implemented to monitor the request count for each VM.

## Prerequisites

To deploy this infrastructure, ensure you have the following prerequisites:

- Azure subscription
- Terraform installed on your local machine

## Getting Started

To deploy the infrastructure, follow these steps:

1. Clone this repository to your local machine.

```shell
git clone <repository-url>

cd <repository-directory>

2. Open the main.tf file and modify the subscription_id parameter under the provider "azurerm" block with your Azure subscription ID.
provider "azurerm" {
  subscription_id = "your-subscription-id"
  # ...
}
3. Initialize Terraform.
terraform init

4. Review the variables in the input.tf file and update them as needed.

5. Plan the infrastructure deployment.
 terraform plan

6. Deploy the infrastructure.
 terraform apply

7. Confirm the deployment by typing yes when prompted
Or use terraform apply -auto-approve .

8. Monitor the deployment process, and once completed, you will have the infrastructure provisioned on Azure.

Configuration
The Terraform code contains the following files:

main.tf: Defines the Azure provider and sets up the necessary resources.
appGway.tf: Contains the configuration for the Azure Application Gateway.
input.tf: Defines input variables used in the Terraform code.
nat.tf: Configures the NAT Gateway.
myScript.sh: Contains the script to be executed on the Apache servers.
network_interface.tf: Configures the network interfaces for the VMs.
networking.tf: Defines the virtual network and subnets.
virtulaMachins.tf: Defines the Azure Linux virtual machines.
Monitoring and Alerts
An alert system is implemented on the Application Gateway to monitor the request count for each VM. If the number of requests exceeds 10 per minute for any application, an email notification will be sent.
