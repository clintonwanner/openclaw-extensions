# Strategist Skill

SKILL.md for strategist skill containing reflection and planning capabilities.

## P1 Proposal Activations

### Reflection-to-Action Bridge (R2A)
Proposal: 2026-02-20 | Status: IMPLEMENTED ✅
Auto-spawns implementation agents for P1 proposals immediately upon reflection completion.

```typescript
import { postReflectionActions } from './reflection-action-bridge';

// Usage: At end of Protocol B (Recursive Optimization)
await postReflectionActions('/path/to/proposal_YYYY-MM-DD.md');
```

## Protocol B Hook

At the end of every strategist reflection:

```typescript
// strategist-reflection-end-hook.ts
async function onReflectionComplete(proposalPath: string) {
  // Auto-spawn implementation agents for P1 proposals
  await postReflectionActions(proposalPath);
}
```

## Exports

```typescript
export {
  extractP1Proposals,
  shouldAutoImplement,
  postReflectionActions
} from './reflection-action-bridge';
```

## Usage in Protocol B

At end of recursive optimization:
```typescript
const proposalPath = `reflections/proposal_${today}.md`;
generateReflection(proposalPath);

// NEW: Auto-activate P1 proposals
await postReflectionActions(proposalPath);
```
