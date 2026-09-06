# Terminal Run

Common Terraform commands for this project.

```bash
# Initialize the working directory (downloads providers, sets up backend)
terraform init

# Preview the changes Terraform will make
terraform plan

# Apply the changes (creates/updates infrastructure)
terraform apply

# Destroy all resources managed by this configuration
terraform destroy
```

## Using a var file

If variable values live in a `.tfvars` file other than the auto-loaded
`terraform.tfvars` / `*.auto.tfvars`, pass it explicitly with `-var-file`:

```bash
terraform plan --var-file="terraform.tfvars"
terraform apply --var-file="terraform.tfvars"
terraform destroy --var-file="terraform.tfvars"
```
