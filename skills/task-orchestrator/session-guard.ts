/**
 * Mandatory Memory Commit Gate (MMCG)
 * Proposal: 2026-02-20 | P1 | Status: IMPLEMENTED
 *
 * Auto-commits session memory for significant work sessions
 * to eliminate silent operational gaps.
 */

import { sessions_spawn } from '../tools/sessions_spawn';
import { exec } from '../tools/exec';

interface Session {
  key: string;
  id: string;
  startTime: number;
  toolCalls: number;
  memoryCommitted?: boolean;
  history?: Array<{ tool: string; result: any }>;
}

interface MemoryCommitResult {
  committed: boolean;
  filePath?: string;
  error?: string;
}

// Thresholds for auto-commit
const COMMIT_THRESHOLDS = {
  durationMs: 60 * 60 * 1000,  // 60 minutes
  toolCalls: 5,
  forceCommit: true  // Skip if already committed
};

// Session tracking registry (in-memory)
const sessionRegistry: Map<string, Session> = new Map();

/**
 * Track session start time and state
 * Call this at session initialization
 */
export function trackSession(session: Session): void {
  sessionRegistry.set(session.key, {
    ...session,
    startTime: Date.now(),
    toolCalls: 0
  });
  console.log(`[MMCG] Tracked session ${session.key}`);
}

/**
 * Increment tool call counter for session
 * Call this after each tool execution
 */
export function incrementToolCall(sessionKey: string): void {
  const session = sessionRegistry.get(sessionKey);
  if (session) {
    session.toolCalls++;
    sessionRegistry.set(sessionKey, session);
  }
}

/**
 * Determine if session warrants auto-commit
 * @param session Session to evaluate
 * @returns boolean
 */
export function shouldAutoCommit(session: Session): boolean {
  // Skip if already committed
  if (session.memoryCommitted) {
    return false;
  }
  
  const duration = Date.now() - session.startTime;
  const significantDuration = duration > COMMIT_THRESHOLDS.durationMs;
  const significantActivity = session.toolCalls > COMMIT_THRESHOLDS.toolCalls;
  
  return significantDuration || significantActivity;
}

/**
 * Trigger automatic memory commit for session
 * @param session Session to commit
 * @returns MemoryCommitResult
 */
export async function triggerMemoryCommit(
  session: Session
): Promise<MemoryCommitResult> {
  if (!shouldAutoCommit(session)) {
    return { committed: false };
  }
  
  const duration = Date.now() - session.startTime;
  const date = new Date().toISOString().split('T')[0];
  
  try {
    // Spawn agent:coder to write memory entry
    const result = await sessions_spawn({
      task: `Write MEMORY.md entry for session ${session.id}.

Extract from session history:
[Task]: Primary objective
[Outcome]: Success/failure summary  
[Blockers]: Any issues encountered

Session stats:
- Duration: ${Math.round(duration / 60000)} minutes
- Tool calls: ${session.toolCalls}
- Session key: ${session.key}

Output to: memory/${date}.md

Format:
# Session ${session.id}
**Date:** ${date}
**Duration:** ${Math.round(duration / 60000)} minutes

## Task
<!-- primary objective -->

## Outcome  
<!-- summary -->

## Blockers
<!-- any blockers -->

Generate and write.
`,
      timeoutSeconds: 120
    });
    
    // Mark as committed
    const trackedSession = sessionRegistry.get(session.key);
    if (trackedSession) {
      trackedSession.memoryCommitted = true;
      sessionRegistry.set(session.key, trackedSession);
    }
    
    return {
      committed: true,
      filePath: `memory/${date}.md`
    };
    
  } catch (error) {
    return {
      committed: false,
      error: `Failed to spawn memory commit: ${error}`
    };
  }
}

/**
 * Session end hook - automatic memory commit if thresholds met
 * Call this before session termination
 */
export async function sessionEndHook(sessionKey: string): Promise<void> {
  const session = sessionRegistry.get(sessionKey);
  if (!session) {
    console.log(`[MMCG] Session ${sessionKey} not tracked, skipping`);
    return;
  }
  
  if (shouldAutoCommit(session)) {
    console.log(`[MMCG] Significant session detected (${session.toolCalls} tool calls, ${Math.round((Date.now() - session.startTime) / 60000)} min). Auto-committing...`);
    const result = await triggerMemoryCommit(session);
    
    if (result.committed) {
      console.log(`[MMCG] ✓ Committed to ${result.filePath}`);
    } else if (result.error) {
      console.error(`[MMCG] ✗ Commit failed: ${result.error}`);
    }
  } else {
    console.log(`[MMCG] Session below thresholds, skipping commit`);
  }
  
  // Cleanup registry
  sessionRegistry.delete(sessionKey);
}

// Export for SKILL.md integration
export const sessionGuard = {
  trackSession,
  incrementToolCall,
  shouldAutoCommit,
  triggerMemoryCommit,
  sessionEndHook
};
