/**
 * Predictive Compaction Scheduler
 * Proposal: 2026-02-14 | P1 | Status: IMPLEMENTED
 *
 * Predicts token usage and schedules compaction proactively
 * to prevent mid-flight context loss.
 */

export type TaskWeight = 'light' | 'medium' | 'heavy';

interface Task {
  name: string;
  estimatedFiles?: number;
  estimatedLines?: number;
  description?: string;
}

interface Session {
  key: string;
  contextTokens: number;
  totalTokens: number;
}

interface CompactionDecision {
  defer: boolean;
  reason?: string;
  recommendedAction?: string;
}

// Token thresholds (aligned with OpenClaw defaults)
const TOKEN_THRESHOLDS = {
  light: { max: 5000 },
  medium: { min: 5000, max: 15000 },
  heavy: { min: 15000 }
};

const COMPACTION_TRIGGERS = {
  heavy: 180000,   // 180K for heavy tasks
  default: 200000  // 200K for others
};

/**
 * Estimate task weight based on scope
 * @param task Task descriptor with file/line estimates
 * @returns TaskWeight classification
 */
export function estimateTaskWeight(task: Task): TaskWeight {
  // Heuristic: files * avg lines per file * tokens per line (~4)
  const fileCount = task.estimatedFiles || 1;
  const lineCount = task.estimatedLines || 100;
  const estimatedTokens = fileCount * lineCount * 4;
  
  if (estimatedTokens < TOKEN_THRESHOLDS.light.max) {
    return 'light';
  } else if (estimatedTokens < TOKEN_THRESHOLDS.medium.max) {
    return 'medium';
  }
  return 'heavy';
}

/**
 * Determine if compaction should run before task
 * @param currentTokens Current session token count
 * @param taskWeight Weight classification
 * @returns boolean
 */
export function shouldCompactFirst(
  currentTokens: number,
  taskWeight: TaskWeight
): boolean {
  const threshold = taskWeight === 'heavy' 
    ? COMPACTION_TRIGGERS.heavy 
    : COMPACTION_TRIGGERS.default;
  
  return currentTokens > threshold;
}

/**
 * Schedule compaction if needed before task execution
 * @param session Current session state
 * @param task Task to be executed
 * @returns CompactionDecision with defer flag
 */
export function scheduleCompactionIfNeeded(
  session: Session,
  task: Task
): CompactionDecision {
  const weight = estimateTaskWeight(task);
  const shouldDefer = shouldCompactFirst(session.totalTokens, weight);
  
  if (shouldDefer) {
    const threshold = weight === 'heavy' 
      ? COMPACTION_TRIGGERS.heavy 
      : COMPACTION_TRIGGERS.default;
    
    return {
      defer: true,
      reason: `Session at ${session.totalTokens.toLocaleString()} tokens exceeds ${threshold.toLocaleString()} threshold for ${weight} tasks`,
      recommendedAction: 'Trigger compaction before task execution'
    };
  }
  
  return { defer: false };
}

/**
 * Pre-flight check with automatic deferral
 * Use this before spawning sub-agents
 */
export function preFlightCheck(
  tokens: number,
  estimatedFiles: number,
  estimatedLines: number
): CompactionDecision {
  const task: Task = {
    name: 'pre-flight',
    estimatedFiles,
    estimatedLines
  };
  
  const weight = estimateTaskWeight(task);
  const decision = scheduleCompactionIfNeeded(
    { key: 'preflight', contextTokens: tokens, totalTokens: tokens },
    task
  );
  
  if (decision.defer) {
    console.log(`[PCS] Task classified as ${weight}, compaction required`);
  }
  
  return decision;
}

// Integration for task-orchestrator/SKILL.md
export const compactionScheduler = {
  estimateTaskWeight,
  shouldCompactFirst,
  scheduleCompactionIfNeeded,
  preFlightCheck
};
