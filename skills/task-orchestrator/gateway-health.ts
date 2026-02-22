/**
 * Gateway Health Monitor (GHM)
 * Pre-flight gateway health check before browser automation
 * 
 * Proposal: reflections/proposal_2026-02-22.md
 * Implementation Date: 2026-02-22
 */

import { exec } from '../utils/exec';

export interface GatewayHealthResult {
  isHealthy: boolean;
  hasZombieProcess: boolean;
  portInUse: boolean;
  port: number;
  recommendations: string[];
}

/**
 * Check if the Gateway is healthy before browser automation
 * Detects zombie processes on the control port
 */
export async function checkGatewayHealth(
  port: number = 18789
): Promise<GatewayHealthResult> {
  const result: GatewayHealthResult = {
    isHealthy: false,
    hasZombieProcess: false,
    portInUse: false,
    port,
    recommendations: []
  };

  try {
    // Check if port is listening
    const socketCheck = await exec({
      command: `ss -tlnp | grep ':${port}' || true`
    });
    
    result.portInUse = socketCheck.includes(`:${port}`);
    
    // Check for zombie or problematic states
    if (result.portInUse) {
      // Look for zombie, defunct, or blocked processes
      const procCheck = await exec({
        command: `ps aux | grep -E '(${port}|openclaw.*gateway|claw.*gateway)' | grep -v grep || true`
      });
      
      result.hasZombieProcess = 
        procCheck.includes('zombie') ||
        procCheck.includes('defunct') ||
        procCheck.includes('<defunct>');
      
      if (result.hasZombieProcess) {
        result.recommendations.push(
          `[GHM] Zombie process detected on port ${port}. Recommend: openclaw gateway restart`
        );
      }
    }

    // Determine health
    result.isHealthy = result.portInUse && !result.hasZombieProcess;
    
    if (!result.portInUse) {
      result.recommendations.push(
        `[GHM] Gateway not listening on port ${port}. Gateway may be stopped.`
      );
    }

  } catch (error) {
    result.recommendations.push(
      `[GHM] Health check failed: ${error instanceof Error ? error.message : String(error)}`
    );
  }

  return result;
}

/**
 * Get browser automation profile based on gateway health
 * Returns recommended profile and any fallback messages
 */
export async function getBrowserProfile(): Promise<{
  profile: 'chrome' | 'openclaw';
  health: GatewayHealthResult;
  fallbackUsed: boolean;
}> {
  const health = await checkGatewayHealth();
  
  // Use Chrome extension fallback if gateway is unhealthy
  const fallbackUsed = !health.isHealthy;
  const profile: 'chrome' | 'openclaw' = health.isHealthy ? 'openclaw' : 'chrome';
  
  if (fallbackUsed) {
    console.log(`[GHM] Gateway unhealthy (${health.hasZombieProcess ? 'zombie' : 'not listening'}). Using Chrome extension fallback.`);
    for (const rec of health.recommendations) {
      console.log(rec);
    }
  }
  
  return { profile, health, fallbackUsed };
}

// Export for R2A tracking
export const GHM_IMPLEMENTATION = {
  version: '1.0.0',
  proposalDate: '2026-02-22',
  status: 'IMPLEMENTED',
  proposal: 'reflections/proposal_2026-02-22.md'
};
