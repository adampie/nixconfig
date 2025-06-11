# CDK

## Project Structure
- Use TypeScript for CDK apps: `cdk init app --language typescript`
- Organize stacks by environment or service: `lib/production-stack.ts`, `lib/staging-stack.ts`
- Use separate files for each major resource: `lib/database.ts`, `lib/api.ts`
- Keep construct classes in `lib/constructs/` directory

## Stack and Construct Design
- Use PascalCase for stack and construct names: `class ApiGatewayStack extends Stack`
- Pass configuration through props interfaces: `interface DatabaseProps { readonly instanceType: string }`
- Use construct composition over inheritance
- Create reusable constructs for common patterns: `class SecureS3Bucket extends Construct`

## Resource Configuration
- Use explicit resource names with environment prefixes: `bucketName: 'myapp-prod-data-bucket'`
- Tag all resources consistently: `Tags.of(this).add('Environment', props.environment)`
- Use CDK constants for common values: `InstanceType.of(InstanceClass.T3, InstanceSize.MICRO)`
- Enable termination protection for production stacks: `terminationProtection: true`

## Security Best Practices
- Use least privilege IAM policies with specific actions and resources
- Enable encryption by default: `encrypted: true`
- Use VPC for network isolation: `vpc: ec2.Vpc.fromLookup(this, 'VPC', { isDefault: true })`
- Store secrets in AWS Secrets Manager: `secretsmanager.Secret.fromSecretArn()`

## Environment Management
- Use context values for environment-specific config: `this.node.tryGetContext('environment')`
- Define environment in `cdk.json`: `"context": { "environment": "production" }`
- Use separate CDK apps for different AWS accounts
- Use cross-stack references sparingly: `Fn.importValue()` or `Stack.of(construct).exportValue()`

## Testing and Deployment
- Write unit tests for constructs: `Template.fromStack(stack).hasResourceProperties()`
- Use `cdk diff` before deployment to review changes
- Use `cdk deploy --require-approval never` for CI/CD pipelines
- Bootstrap CDK in each region: `cdk bootstrap aws://account/region`
