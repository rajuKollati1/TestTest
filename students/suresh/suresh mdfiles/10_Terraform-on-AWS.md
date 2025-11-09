# Terraform on AWS — Professional Setup

## Initialize
```bash
terraform init
terraform plan
terraform apply -auto-approve
```

## Example EC2 Setup
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "Terraform-EC2"
  }
}
```
