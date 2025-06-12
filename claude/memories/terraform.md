# Terraform

## Module Structure
- Use standard file names: `variables.tf`, `outputs.tf`, `locals.tf`, and `main.tf` in each module
- Use lowercase with underscores for resource names: `aws_instance.web_server`
- Run `terraform fmt` before committing code

## Variables and Data
- Define all variables in `variables.tf` with description and type
- Use specific variable types: `string`, `number`, `bool`, `list(string)`, `map(string)`
- Add validation blocks: `validation { condition = length(var.name) > 0; error_message = "Name cannot be empty." }`
- Provide sensible defaults: `default = "t3.micro"`
- Use data sources instead of hardcoded values: `data.aws_caller_identity.current.account_id`

## Outputs
- Output useful values for module composition: `output "instance_id" { value = aws_instance.web.id }`
- Include descriptions: `description = "The ID of the EC2 instance"`

## Security
- Use specific resource ARNs instead of wildcards: `arn:aws:s3:::bucket-name/*`
- Enable encryption at rest
- Enable encryption in transit
- Implement least privilege IAM policies with minimal required permissions
