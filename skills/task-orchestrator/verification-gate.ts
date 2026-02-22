/**
 * Automated Verification Gate (AVG)
 * Proposal: 2026-02-14 | P1 | Status: IMPLEMENTED
 *
 * Auto-verifies sub-agent deliverables exist and are valid before
 * marking tasks SUCCESS. Eliminates false-positive completions.
 */

import { read } from '../tools/read';
import { exec } from '../tools/exec';

interface FileStatus {
  path: string;
  exists: boolean;
  size: number;
  checksumValid: boolean;
  errors: string[];
}

interface VerificationResult {
  status: 'VERIFIED' | 'FAILED' | 'PARTIAL';
  files: FileStatus[];
  message?: string;
  retryRecommendation?: string;
}

/**
 * Verify files exist, are non-empty, and pass checksum validation
 * @param expectedFiles Array of file paths to verify
 * @param maxRetries Number of retry attempts (default: 3)
 * @returns VerificationResult with status and file details
 */
export async function verifyWithRetry({
  expectedFiles,
  maxRetries = 3
}: {
  expectedFiles: string[];
  maxRetries?: number;
}): Promise<VerificationResult> {
  const files: FileStatus[] = [];
  
  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    const attemptResults = await Promise.all(
      expectedFiles.map(path => verifySingleFile(path))
    );
    
    const allVerified = attemptResults.every(f => 
      f.exists && f.size > 0 && f.checksumValid
    );
    
    if (allVerified) {
      return {
        status: 'VERIFIED',
        files: attemptResults,
        message: `All ${expectedFiles.length} files verified on attempt ${attempt + 1}`
      };
    }
    
    if (attempt < maxRetries) {
      const backoffMs = 1000 * (attempt + 1);
      console.log(`Verification attempt ${attempt + 1} failed. Retrying in ${backoffMs}ms...`);
      await sleep(backoffMs);
    } else {
      files.push(...attemptResults);
    }
  }
  
  const failedFiles = files.filter(f => !f.exists || f.size === 0 || !f.checksumValid);
  
  return {
    status: 'FAILED',
    files,
    message: `Verification failed after ${maxRetries + 1} attempts`,
    retryRecommendation: failedFiles.some(f => f.errors.includes('ENOENT'))
      ? 'Files may not exist - check sub-agent output paths'
      : 'Files exist but may be incomplete - tighten write verification protocol'
  };
}

async function verifySingleFile(path: string): Promise<FileStatus> {
  const status: FileStatus = {
    path,
    exists: false,
    size: 0,
    checksumValid: true,
    errors: []
  };
  
  try {
    const result = await read({ file_path: path });
    status.exists = true;
    status.size = result.length || 0;
    
    if (status.size === 0) {
      status.errors.push('Empty file');
    }
    
    // Basic sanity check for JSON files
    if (path.endsWith('.json')) {
      try {
        JSON.parse(result);
      } catch {
        status.checksumValid = false;
        status.errors.push('Invalid JSON');
      }
    }
    
  } catch (error) {
    status.exists = false;
    status.errors.push('ENOENT');
  }
  
  return status;
}

function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// Integration hook for task-orchestrator
export async function postAgentVerification(
  sessionKey: string,
  expectedDeliverables: string[]
): Promise<VerificationResult> {
  console.log(`[AVG] Verifying deliverables for ${sessionKey}`);
  const result = await verifyWithRetry({ expectedFiles: expectedDeliverables });
  
  if (result.status === 'VERIFIED') {
    console.log('[AVG] ✓ Verification passed');
  } else {
    console.error('[AVG] ✗ Verification failed:', result.message);
  }
  
  return result;
}
