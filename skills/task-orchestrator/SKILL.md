# Task Orchestrator Skill

SKILL.md for task-orchestrator skill containing P1 proposal implementations.

## P1 Proposal Activations

### Automated Verification Gate (AVG)
Proposal: 2026-02-14 | Status: IMPLEMENTED ✅
Auto-verifies sub-agent deliverables exist and are valid before marking SUCCESS.

```typescript
import { verifyWithRetry } from './verification-gate';

// Usage: Verify files before accepting sub-agent completion
const result = await verifyWithRetry({
  expectedFiles: ['./src/output.ts', './tests/output.test.ts'],
  maxRetries: 3
});
```

### Predictive Compaction Scheduler (PCS)
Proposal: 2026-02-14 | Status: IMPLEMENTED ✅
Predicts token usage and schedules compaction proactively.

```typescript
import { preFlightCheck } from './compaction-scheduler';

// Usage: Check before spawning heavy tasks
const decision = preFlightCheck(currentTokens, estimatedFiles, estimatedLines);
if (decision.defer) {
  await compactSession();
}
```

### Mandatory Memory Commit Gate (MMCG)
Proposal: 2026-02-20 | Status: IMPLEMENTED ✅
Auto-commits session memory for significant work sessions.

```typescript
import { sessionGuard, sessionEndHook } from './session-guard';

// Usage: At session start
sessionGuard.trackSession(session);

// Usage: At session end (AUTOMATIC)
await sessionEndHook(session.key);
```

## Exports

```typescript
export { verifyWithRetry } from './verification-gate';
export { compactionScheduler, preFlightCheck } from './compaction-scheduler';
export { sessionGuard, sessionEndHook } from './session-guard';
```

## Future Integration

Add to main agent SKILL.md imports:
```typescript
import { verifyWithRetry, preFlightCheck, sessionEndHook } from 'task-orchestrator';
```
