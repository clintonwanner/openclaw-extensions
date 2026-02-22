/**
 * Reflection-to-Action Bridge (R2A) with Reviewer Gate
 * Proposal: 2026-02-20 | P1 | Status: IMPLEMENTED
 *
 * Auto-spawns reviewer for P1 proposals, then implementation if approved.
 */

import { sessions_spawn } from '../tools/sessions_spawn';
import { read } from '../tools/read';

interface Proposal {
  id: string;
  title: string;
  priority: string; // 'P0' | 'P1' | 'P2'
  lineRef?: string;
  implementationFile?: string;
  status: 'proposed' | 'in_progress' | 'implemented' | 'rejected' | 'deferred';
}

interface ExtractionResult {
  proposals: Proposal[];
  date: string;
  agent: string;
}

interface ReviewResult {
  status: 'APPROVED' | 'REVISED' | 'DEFERRED';
  feedback?: string;
  revisedProposal?: Proposal;
}

/**
 * Extract P1 proposals from reflection Markdown
 */
export async function extractP1Proposals(proposalPath: string): Promise<Proposal[]> {
  const content = await read({ file_path: proposalPath });
  const proposals: Proposal[] = [];
  
  const dateMatch = proposalPath.match(/proposal_(\d{4}-\d{2}-\d{2})/);
  const date = dateMatch ? dateMatch[1] : 'unknown';
  
  const lines = content.split('\n');
  let currentSection: Proposal | null = null;
  let lineNumber = 0;
  
  for (const line of lines) {
    lineNumber++;
    const priorityMatch = line.match(/\|\s*(\d+)\s*\|.*\|\s*(P[0-2])\s*\|/);
    const headerMatch = line.match(/^(#{1,3})\s*(.+)/);
    
    if (priorityMatch) {
      const priority = priorityMatch[2];
      if (priority === 'P1') {
        currentSection = {
          id: `PROP-${date}-${proposals.length + 1}`,
          title: '',
          priority: 'P1',
          lineRef: `${proposalPath}#L${lineNumber}`,
          status: 'proposed'
        };
      }
    }
    
    if (currentSection && headerMatch) {
      currentSection.title = headerMatch[2].trim();
      proposals.push(currentSection);
      currentSection = null;
    }
  }
  
  return proposals;
}

/**
 * Filter proposals for actionable vs. research-only
 */
export function shouldAutoImplement(proposal: Proposal): boolean {
  const informationalKeywords = [
    'research', 'analysis', 'investigation', 'study', 'survey', 'review'
  ];
  const titleLower = proposal.title.toLowerCase();
  const isInformational = informationalKeywords.some(kw => 
    titleLower.includes(kw)
  );
  return !isInformational;
}

/**
 * NEW: Spawn agent:reviewer to evaluate proposal before implementation
 */
export async function spawnReviewerAgent(proposal: Proposal): Promise<ReviewResult> {
  console.log(`[R2A] Spawning reviewer for: ${proposal.title}`);

  try {
    const result = await sessions_spawn({
      task: `Review P1 proposal: "${proposal.title}"

Source: ${proposal.lineRef}
Priority: ${proposal.priority}
ID: ${proposal.id}

Review Checklist:
1. COMPLETENESS — Does proposal have clear implementation details?
2. FEASIBILITY — Can this be implemented given current architecture?
3. PRIORITY ACCURACY — Is P1 appropriate, or should it be P0/P2?
4. ACTIONABILITY — Is this research-only or truly implementable?
5. RISK ASSESSMENT — Any blast radius concerns?

Return ONE of:
- APPROVED: Proposal ready for implementation
- REVISED: Needs changes (provide specific feedback)
- DEFERRED: Not actionable now (provide reason)

Be critical. Reject incomplete proposals.`,
      timeoutSeconds: 300
    });

    // Parse reviewer response
    const response = result.toString().toUpperCase();
    if (response.includes('DEFERRED')) {
      return { status: 'DEFERRED', feedback: result.toString() };
    } else if (response.includes('REVISED')) {
      return { status: 'REVISED', feedback: result.toString() };
    }
    return { status: 'APPROVED', feedback: result.toString() };

  } catch (error) {
    console.error(`[R2A] Reviewer failed for ${proposal.title}:`, error);
    return { status: 'DEFERRED', feedback: `Reviewer error: ${error}` };
  }
}

/**
 * REVISED: Main entry point — adds reviewer gate before implementation
 */
export async function postReflectionActions(proposalPath: string): Promise<string[]> {
  const results: string[] = [];
  
  console.log(`[R2A] Processing proposals from: ${proposalPath}`);
  
  // Extract P1 proposals
  const proposals = await extractP1Proposals(proposalPath);
  const p1Proposals = proposals.filter(p => 
    p.priority === 'P1' && shouldAutoImplement(p)
  );
  
  if (p1Proposals.length === 0) {
    console.log('[R2A] No actionable P1 proposals found');
    return results;
  }
  
  // Limit to first P1 to prevent saturation
  const proposal = p1Proposals[0];
  console.log(`[R2A] Reviewing: ${proposal.title}`);
  
  // NEW: REVIEWER GATE
  const review = await spawnReviewerAgent(proposal);
  
  switch (review.status) {
    case 'APPROVED':
      console.log(`[R2A] ✓ Proposal APPROVED — spawning implementation`);
      // Proceed to implementation
      const implResult = await spawnImplementationAgent(proposal);
      results.push(implResult);
      break;
      
    case 'REVISED':
      console.log(`[R2A] ⚠ Proposal needs REVISION:`);
      console.log(review.feedback);
      // Log to memory for manual review
      await logDeferredProposal(proposal, review.feedback, 'REVISED');
      break;
      
    case 'DEFERRED':
      console.log(`[R2A] ✗ Proposal DEFERRED:`);
      console.log(review.feedback);
      await logDeferredProposal(proposal, review.feedback, 'DEFERRED');
      break;
  }
  
  return results;
}

/**
 * Log deferred proposals for later review
 */
async function logDeferredProposal(
  proposal: Proposal,
  feedback: string,
  status: 'REVISED' | 'DEFERRED'
): Promise<void> {
  const logEntry = `
## Deferred Proposal: ${proposal.title}
**Status:** ${status}
**Date:** ${new Date().toISOString()}
**ID:** ${proposal.id}
**Line:** ${proposal.lineRef}

**Feedback:**
${feedback}

---
`;
  console.log(logEntry);
  // Could write to memory/deferred-proposals.md if desired
}

/**
 * Spawn implementation agent (unchanged from original)
 */
async function spawnImplementationAgent(proposal: Proposal): Promise<string> {
  console.log(`[R2A] Spawning implementation for: ${proposal.title}`);

  try {
    const result = await sessions_spawn({
      task: `Implement proposal: "${proposal.title}"

Source: ${proposal.lineRef}
Priority: ${proposal.priority}
ID: ${proposal.id}

Requirements:
1. Create implementation files as specified in the proposal
2. Add tests where applicable  
3. Update relevant SKILL.md with usage examples
4. Report SUCCESS or FAILURE with detailed logs

If proposal specifies exact files/paths, follow them.
If unclear, create minimal working implementation.

Expected output:
- Implementation file(s)
- Test files (if applicable)
- SKILL.md updates with usage examples
- SUCCESS/FAILURE report with logs`,
      timeoutSeconds: 300
    });

    console.log(`[R2A] Implementation spawned: ${result}`);
    return result;

  } catch (error) {
    console.error(`[R2A] Implementation failed:`, error);
    throw error;
  }
}

// LEGACY: Direct implementation spawn (for non-reviewed workflows)
export async function spawnImplementationDirect(proposal: Proposal): Promise<string> {
  return spawnImplementationAgent(proposal);
}

// Export for SKILL.md
export const reflectionActionBridge = {
  extractP1Proposals,
  shouldAutoImplement,
  spawnReviewerAgent,
  postReflectionActions,
  spawnImplementationDirect
};
