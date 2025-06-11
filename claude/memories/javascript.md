# Javascript

## Modern JavaScript
- Use `const` and `let` instead of `var` for block scoping
- Use async/await for promises: `const data = await fetch('/api')`
- Use ES6 modules: `import { component } from './module'` and `export { function }`
- Use optional chaining: `user?.profile?.email`
- Use nullish coalescing: `const name = user.name ?? 'Anonymous'`

## TypeScript
- Use TypeScript for better type safety: `npm install -D typescript`
- Define interfaces for data structures: `interface User { id: string; email: string }`
- Avoid `any` type; use `unknown` when type is uncertain
- Configure strict settings in `tsconfig.json`: `"strict": true`
- Use union types: `type Status = 'loading' | 'success' | 'error'`

## Code Quality
- Use Prettier for formatting: `npx prettier --write .`
- Use ESLint with strict rules: `npx eslint --ext .ts,.tsx src/`
- Use consistent naming: camelCase for variables, PascalCase for classes
- Use kebab-case for file names: `user-profile.component.ts`

## Error Handling
- Handle async errors with try/catch: `try { await api.call() } catch (error) { console.error(error) }`
- Use proper error types instead of throwing strings
- Implement proper input validation

## Security
- Run `npm audit` regularly to identify vulnerabilities
- Validate and sanitize all user inputs
- Use HTTPS for all API calls
- Use environment variables: `process.env.API_URL`