# TF-ECS-Greenfield

This project contains a plug-and-play boilerplate to host a new project onto AWS ECS

## Infrastructure Diagram

(Coming Soon)

## Initialization

### Backend S3 Bucket Creation

To create an S3 bucket for the backend (state management), first run an independent TF script
- Move to the utils directory
```bash
cd utils/
```

- Rename the bucket name in `init.tf` to a globally unique name

- Run the TF script to create the bucket
```bash
terraform init
terraform plan
terraform apply
```

- Transfer the bucket name to the project's main backend file (`backends.tf`)