# terraform-aws-openvpn

This repository contains Terraform configurations for deploying an OpenVPN server on AWS.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS account with appropriate permissions

## Usage

1. Clone the repository:
  ```sh
  git clone https://github.com/yourusername/terraform-aws-openvpn.git
  cd terraform-aws-openvpn
  ```

2. Initialize Terraform:
  ```sh
  terraform init
  ```

3. Review and modify the `variables.tf` file to customize the deployment.

4. Apply the Terraform configuration:
  ```sh
  terraform apply
  ```

5. Confirm the apply action with `yes`.

## Variables

| Name                | Description                        | Type   | Default |
|---------------------|------------------------------------|--------|---------|
| `aws_region`        | The AWS region to deploy resources | string | `us-west-2` |
| `instance_type`     | EC2 instance type for OpenVPN      | string | `t2.micro` |
| `key_name`          | SSH key pair name                  | string | n/a     |
| `vpc_id`            | VPC ID for the deployment          | string | n/a     |
| `subnet_id`         | Subnet ID for the deployment       | string | n/a     |

## Outputs

| Name                | Description                        |
|---------------------|------------------------------------|
| `openvpn_server_ip` | The public IP address of the OpenVPN server |

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.
