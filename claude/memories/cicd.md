# CICD

## Pipeline Performance
- Enable parallel execution with `jobs.<job_id>.strategy.matrix`
- Fail fast by running linting and unit tests before integration tests
- Cache dependencies with `actions/cache@v4` using lock file hashes as keys
- Use matrix builds: `strategy: matrix: node-version: [18, 20, 22]`

## GitHub Actions Best Practices
- Pin action versions to specific releases: `actions/checkout@v4.1.7`
- Use official marketplace actions when available
- Store sensitive data in repository secrets: `${{ secrets.API_KEY }}`
- Use `GITHUB_TOKEN` for repository operations

## Security
- Scan dependencies with `actions/dependency-review-action@v4`
- Require signed commits: `git config --global commit.gpgsign true`
- Use least privilege permissions: `permissions: contents: read`

## Testing and Quality
- Run unit tests on every pull request and push
- Generate coverage reports with `--coverage` flag
- Enforce minimum coverage thresholds: `--fail-under=80`
- Run security scans automatically

## Deployment Workflows
- Implement promotion workflows: dev → staging → production
- Use deployment protection rules for production environments
- Version artifacts with semantic versioning: `v1.2.3`

## Monitoring and Observability
- Set up Slack/email notifications for pipeline failures
- Track DORA metrics: deployment frequency, lead time, MTTR
- Use structured logging with JSON format
- Monitor pipeline success rates and failure patterns
