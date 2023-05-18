# AWS Terraform Lucee with ALB

> An example for AWS Terraform setup with Lucee AMI image without public IPv4 and Application Load Balancer.

## Prerequisites

To create the infrastructure in this project you will need:

1. [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) (1.3.0+) installed.
2. [AWS account](https://aws.amazon.com/free)  that allow you to create resources and AMI Image ID for Lucee.
3. Create `terraform.tfvars` with following
    ```hcl
    # required variables
    aws_region     = "us-east-1"
    aws_access_key = "<your-access-key>"
    aws_secret_key = "<your-secret-key>"
    ami_lucee_id   = "<ami-image-id-with-lucee>"
    # optional variables
    vpc_id = "<existing-vpc-id>"
    enable_application_load_balancer = true
    enable_network_load_balancer     = true
    ssh_ingress_rules = [
      { description = "Developer#1 IP", cidr_blocks = ["11.22.33.44/32"] },
      { description = "Developer#2 IP", cidr_blocks = ["55.66.77.88/32","66.77.88.99/32"] }
    ]
    ```
4. Initialize modules with `terraform init`.
5. Create the infrastructure with `terraform apply`.
6. Destroy the infrastructure with `terraform destroy`.

## Modules

Modules are used to encapsulate the complex logic

### Module `load_balancers`

The module to provision an application and network load balancer for Lucee instance.

##### Inputs

- **aws_instance_id**: `string` - The AMI ID from the Lucee instance.
- **enable_application_load_balancer**: `bool` - (Optional) If true, creates application load balancer. Default value is true.
- **enable_network_load_balancer**: `bool` - (Optional) If true, creates network load balancer. Default value is true.
- **name**: `string` - (Optional) The name of the LB that will be used as prefix. Default value is lucee.
- **security_group_alb**: `string` - A security group ID to assign to the application load balancer.
- **subnets**: `list(string)` - A list of subnet IDs to attach to the load balancers.
- **vpc_id**: `string` - The VPC ID in which to create the target groups.

##### Outputs

- **alb_dns_name** - The DNS name of the application load balancer.
- **nlb_dns_name** - The DNS name of the network load balancer (use it for SSH connections).

### Module `security`

The module to create SSH key and security groups.

##### Inputs

- **name**: `string` - (Optional) The name for security groups that will be used as prefix. Default value is lucee.
- **ssh_ingress_rules**: `list(object)` - The Configuration block for ingress rules to open port 22.
  Use `description` to specify developer name and `cidr_blocks` for list of developer IP addresses.
- **vpc_cidr_block**: `string` - CIDR block for the network load balancer health check.
- **vpc_id**: `string` - The VPC ID in which to create the security groups.

##### Outputs

- **sg_alb** - The security group ID that will be attached to application load balancer.
- **sg_ec2** - The security group ID that will be attached to Lucee EC2 instance.
- **sg_nlb** - The security group ID that will be attached to Lucee EC2 instance and specifies IP addresses for SSH connection.
- **ssh_key_name** - The name of AWS Keypair used later by EC2 instance provisioning.
- **ssh_private_key** - (sensitive) The SSH private key that can be used by SSH into EC2.

### Module `vpc`

The module to provision a VPC:

- it can create a new VPC or
- read information from the existing VPC

> NB! if you leave `vpc_id` is empty, then a new VPC will be created, otherwise specify the existing VPC.

##### Inputs

- **name**: `string` - (Optional) The name for a VPC. Default value is lucee.
- **vpc_id**: `string` - (Optional) The VPC ID that can be imported via data sources. Default is empty string.

##### Outputs

- **subnet_ids** - THe subnet IDs where all infrastructure will be created.
- **vpc_id** - The VPC ID where all infrastructure will be created.
- **vpc_cidr_block** - The CIDR block of the VPC where all infrastructure will be created.

## Tricks

Run `terraform output` command to see all needed information about the created infrastructure, e.g.

```sh
$ terraform output
ssh = {
  "host" = "lucee-nlb-c8adb0823037d190.elb.us-east-1.amazonaws.com"
}
ssh_private_key = <sensitive>
web = {
  "http_url" = "http://lucee-alb-2102024478.us-east-1.elb.amazonaws.com"
  "private_ip" = "172.31.91.126"
}
```

Use `ssh.host` value to ssh into the EC2 instance. You can obtain SSH private key by executing
`terraform output ssh_private_key` command. You can output `ssh_private_key` in raw and redirect the content
into the file, so you can use it later by ssh connection

```sh
$ terraform output -raw ssh_private_key > ~/.ssh/lucee.key
$ chmod 0600 ~/.ssh/lucee.key
$ ssh -i ~/.ssh/lucee.key ubuntu@lucee-nlb-c8adb0823037d190.elb.us-east-1.amazonaws.com
```
