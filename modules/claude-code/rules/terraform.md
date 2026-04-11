---
description: Terraform tagging conventions
paths:
  - "**/*.tf"
---

When writing or modifying Terraform code:

- Use kebab-case for all tag and label keys across AWS and GCP resources (e.g. `cost-centre`, not `cost_centre` or `CostCentre`). The exception is AWS's `Name` tag which is capitalised by convention
- Ensure every AWS provider block includes a `default_tags` block and every GCP provider includes `default_labels`. If one is missing, add it
- Add resource-level tags where they serve a purpose beyond the defaults. For example, AWS resources that appear in the console (EC2 instances, RDS, ELB, etc.) should have a `Name` tag so they are identifiable
