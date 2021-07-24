# aws-rmq

Immutable infrastructure for running **sandbox** RabbitMQ cluster on AWS EC2 instances.

## Prerequisites

- Packer
- Terraform

## Guide

1. Build AMI.

```bash
cd images
packer build -var="erlang_cookie=<your_cookie>" .
```

2. Deploy infrastructure.

```bash
cd infra
terraform init
terraform apply
```
