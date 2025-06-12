# Security

## Input Validation & Sanitization
- Always validate all user inputs at application boundaries
- Use allowlists rather than denylists for input validation
- Sanitize data based on context (HTML, SQL, shell commands)
- Implement proper encoding for output contexts
- Never trust user input, even from authenticated users

## Authentication & Authorization
- Implement multi-factor authentication (MFA) where possible
- Use strong password policies and consider passwordless authentication
- Apply principle of least privilege for all access controls
- Implement proper session management with secure tokens
- Use role-based access control (RBAC) with granular permissions
- Always verify authorization on server-side, not client-side

## Secure Coding Standards
- Use parameterized queries to prevent SQL injection
- Implement CSRF protection for state-changing operations
- Use secure headers (HSTS, CSP, X-Frame-Options, etc.)
- Validate content types and file uploads rigorously
- Implement proper error handling without information disclosure
- Use secure random number generation for security-sensitive operations

## Secrets & Credential Management
- Never hardcode secrets, API keys, or passwords in source code
- Use environment variables or dedicated secret management systems
- Rotate secrets regularly and have revocation procedures
- Use encrypted storage for sensitive configuration
- Implement proper key derivation functions for password storage
- Consider using service accounts and workload identity where available

## Dependency Management
- Regularly scan and update dependencies for known vulnerabilities
- Use dependency pinning and lock files
- Monitor security advisories for used dependencies
- Implement automated dependency update workflows
- Use tools like Dependabot, Snyk, or similar for vulnerability scanning
- Consider using private package repositories for internal dependencies

## Data Protection
- Encrypt sensitive data at rest and in transit
- Use TLS 1.2+ for all external communications
- Implement proper data classification and handling procedures
- Use secure deletion methods for sensitive data
- Implement data minimization principles
- Consider data residency and sovereignty requirements

## Logging & Monitoring
- Log security-relevant events without exposing sensitive data
- Implement centralized logging with proper retention policies
- Monitor for suspicious activities and implement alerting
- Use structured logging for better analysis
- Implement audit trails for compliance requirements
- Never log passwords, tokens, or other sensitive credentials

## Network Security
- Use firewalls and network segmentation
- Implement proper certificate validation
- Use VPNs or private networks for sensitive communications
- Regularly scan for open ports and unnecessary services
- Implement rate limiting and DDoS protection
- Use allowlisting for network access where possible

## Container & Infrastructure Security
- Use minimal base images and multi-stage builds
- Scan container images for vulnerabilities
- Implement proper resource limits and security contexts
- Use network policies and service meshes for communication security
- Keep runtime environments updated and patched
- Implement proper backup and disaster recovery procedures

## Code Review & Testing
- Implement mandatory security code reviews
- Use static analysis security testing (SAST) tools
- Perform dynamic application security testing (DAST)
- Implement security unit tests for critical functions
- Use penetration testing for critical applications
- Consider threat modeling for new features and systems

## Incident Response
- Maintain an incident response plan
- Implement proper backup and recovery procedures
- Have communication plans for security incidents
- Regularly test incident response procedures
- Maintain vendor contact information for security issues
- Document lessons learned from security incidents
