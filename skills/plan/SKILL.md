# Plan Skill

Actor-Critic architecture for iterative plan refinement with reviewer feedback.

## Overview

This skill implements an Actor-Critic pattern where a strategist (actor) drafts plans and a reviewer (critic) evaluates them. Iteration continues until the plan is approved or max iterations reached.

## Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Strategist  │ ──► │  Reviewer   │ ──► │  Approve?   │
│  (Actor)     │     │  (Critic)   │     │             │
└─────────────┘     └─────────────┘     └──────┬──────┘
       ▲                                         │
       └─────────────────────────────────────────┘
                         (Revise if rejected)
```

## Usage

```typescript
import { planWithReview } from './plan';

const result = await planWithReview({
  task: "Plan a migration from React 17 to 18",
  maxIterations: 2  // default
});

// Returns: { status: 'APPROVED' | 'REVISE', plan: string }
```

## Implementation

### Main Function

```typescript
/**
 * Creates a plan through iterative actor-critic refinement.
 * 
 * @param task - The task to plan for
 * @param maxIterations - Maximum review rounds (default: 2)
 * @returns Object with status and final plan
 */
async function planWithReview({ 
  task, 
  maxIterations = 2 
}: { 
  task: string; 
  maxIterations?: number;
}): Promise<{ status: 'APPROVED' | 'REVISE'; plan: string }> {
  
  let currentDraft: string | null = null;
  let sessionKey: string | null = null;
  
  // Step 1: Initial Draft by strategist
  const draftSession = await task({
    agent: 'agent:strategist',
    prompt: `Create a detailed plan for: ${task}\n\nInclude:\n- Phase breakdown\n- Dependencies\n- Risk assessment\n- Success criteria`
  });
  sessionKey = draftSession.sessionKey;
  
  // FIXED: Fetch content via sessions_history before passing to next agent
  // This fixes object serialization bug where we were passing session object references
  currentDraft = getLastResponse(sessionKey);
  
  // Step 2: Review loop (max iterations)
  for (let iteration = 0; iteration < maxIterations; iteration++) {
    
    // Reviewer evaluates
    const reviewSession = await task({
      agent: 'agent:reviewer',
      prompt: `Review this plan:\n\n${currentDraft}\n\nCheck:\n1. Completeness - all phases covered?\n2. Dependencies - are they identified?\n3. Risks - are they realistic?\n4. Metrics - are success criteria measurable?\n\nOutput EXACTLY:\nSTATUS: APPROVED\nOR\nSTATUS: REVISE\nFeedback: [specific feedback for revision]`
    });
    
    // FIXED: Fetch content via sessions_history before checking
    const reviewResponse = getLastResponse(reviewSession.sessionKey);
    
    // CRITICAL: Use strict prefix match, not .includes()
    // This prevents false positives from partial matches in draft content
    if (reviewResponse.startsWith('STATUS: APPROVED')) {
      return {
        status: 'APPROVED',
        plan: currentDraft
      };
    }
    
    // Check if reviewer wants revisions
    if (reviewResponse.startsWith('STATUS: REVISE')) {
      // Extract feedback (everything after first newline or after "STATUS: REVISE")
      const feedback = reviewResponse.replace(/^STATUS: REVISE[\s:]*/, '').trim();
      
      // Strategist revises with feedback
      const reviseSession = await task({
        agent: 'agent:strategist',
        prompt: `Revise this plan based on reviewer feedback:\n\nCurrent Plan:\n${currentDraft}\n\nFeedback:\n${feedback}\n\nOutput the complete revised plan addressing all feedback points.`
      });
      
      // FIXED: Fetch updated draft from sessions history
      currentDraft = getLastResponse(reviseSession.sessionKey);
    } else {
      // If reviewer didn't follow format, treat as needing revision
      const reviseSession = await task({
        agent: 'agent:strategist',
        prompt: `Revise this plan. The reviewer said:\n\n${reviewResponse}\n\nCurrent Plan:\n${currentDraft}\n\nPlease ensure your revision follows the required format with clear phases, dependencies, risks, and success criteria.`
      });
      
      // FIXED: Fetch updated draft from sessions history
      currentDraft = getLastResponse(reviseSession.sessionKey);
    }
  }
  
  // Step 3: Return final plan (best effort if not approved)
  return {
    status: 'REVISE',
    plan: currentDraft
  };
}
```

### Helper Function

```typescript
/**
 * Fetches the last assistant message from session history.
 * 
 * Uses sessions_history to retrieve content, filters for assistant
 * messages, and returns the most recent response.
 * 
 * This helper is REQUIRED to fix object serialization bugs where
 * session objects passed between agents cause downstream failures.
 * 
 * @param sessionKey - The session key from task() call
 * @returns The text content of the last assistant message
 */
function getLastResponse(sessionKey: string): string {
  // Retrieve session history
  const history = sessions_history({ sessionKey });
  
  // Filter for assistant messages
  const assistantMessages = history.filter(
    (msg: { role: string; content: string }) => msg.role === 'assistant'
  );
  
  // Return last message content, or empty string if none
  if (assistantMessages.length === 0) {
    return '';
  }
  
  return assistantMessages[assistantMessages.length - 1].content;
}
```

## Reviewer Output Format

The reviewer agent **MUST** output exactly one of:

### Approved
```
STATUS: APPROVED
```

### Requires Revision
```
STATUS: REVISE
Feedback:
- [Specific issue 1] needs [specific action]
- [Specific issue 2] is incomplete, add [specific detail]
- Consider [alternative approach] for [problem area]
```

## Commands

### Initialize
```bash
# No initialization required
```

### Execute
```typescript
// Via Code
cd /home/prisoner/.openclaw/skills/plan && node -e ""

// Via OpenClaw agent:strategist
// Uses task() calls as shown above
```

## Dependencies

- `agent:strategist` - for plan drafting and revision
- `agent:reviewer` - for quality gates and review

## Error Handling

- If `sessions_history` fails, throws with context
- If max iterations exhausted, returns best-effort plan with `status: 'REVISE'`
- If reviewer output malformed, attempts recovery with generic revision

## Testing

```typescript
// Test: Basic plan creation
const result = await planWithReview({
  task: "Migrate legacy codebase to TypeScript",
  maxIterations: 2
});

assert(result.status === 'APPROVED', 'Should be approved after review');
assert(result.plan.includes('Phase'), 'Should include phase breakdown');
assert(result.plan.includes('Risk'), 'Should include risk assessment');
```

## Notes

- **Serialization Bug Fixed:** Always use `getLastResponse()` to extract string content from session objects before passing to next agent
- **Approval Check:** Strictly use `.startsWith('STATUS: APPROVED')` - no includes(), no contains(), no regex - prefix match only
- **Iteration Cap:** Hard limit at 2 iterations to prevent runaway loops
- **Feedback Loop:** Reviewer feedback must be actionable and specific for best results
