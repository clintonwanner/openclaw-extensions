import { execSync, spawn } from 'child_process';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';
import { existsSync, writeFileSync, mkdirSync } from 'fs';
import { reportTest, reportLint, reportBuild } from './reporters.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = '/app/.openclaw/workspace/kitchen-app';
const GIT_HOOKS = resolve(ROOT, '.git/hooks');

function ensureRoot() {
  if (!existsSync(ROOT)) {
    throw new Error(`Kitchen app not found at ${ROOT}`);
  }
  return ROOT;
}

function run(cmd, args, { json = false } = {}) {
  return new Promise((res, rej) => {
    const proc = spawn('npm', ['run', cmd], {
      cwd: ensureRoot(),
      stdio: ['pipe', 'pipe', 'pipe']
    });
    
    let stdout = '';
    let stderr = '';
    
    proc.stdout.on('data', d => stdout += d);
    proc.stderr.on('data', d => stderr += d);
    
    proc.on('close', code => {
      if (code !== 0) {
        rej({ stdout, stderr, code });
      } else {
        res({ stdout, stderr });
      }
    });
  });
}

export const commands = {
  async test() {
    try {
      const result = await run('test:run');
      reportTest(result.stdout, true);
      return true;
    } catch (err) {
      reportTest(err.stdout || err.stderr, false);
      process.exit(1);
    }
  },

  async lint() {
    try {
      execSync('npm run lint', { cwd: ensureRoot(), stdio: 'pipe' });
      console.log('✓ Lint passed');
      return true;
    } catch (err) {
      reportLint(err.stdout?.toString() || err.stderr?.toString() || err.message);
      process.exit(1);
    }
  },

  async build() {
    try {
      execSync('npm run build', { cwd: ensureRoot(), stdio: 'pipe' });
      reportBuild();
      return true;
    } catch (err) {
      console.error('✗ Build failed');
      console.error(err.stderr?.toString() || err.message);
      process.exit(1);
    }
  },

  async check() {
    console.log('Running full check...\n');
    console.log('1. Lint...');
    try {
      await this.lint();
    } catch {
      process.exit(1);
    }
    
    console.log('\n2. Test...');
    try {
      execSync('npm run test:run', { cwd: ensureRoot(), stdio: 'inherit' });
    } catch {
      process.exit(1);
    }
    
    console.log('\n3. Build...');
    try {
      execSync('npm run build', { cwd: ensureRoot(), stdio: 'pipe' });
      reportBuild();
    } catch {
      process.exit(1);
    }
    
    console.log('\n✓ All checks passed');
  },

  async outdated() {
    try {
      execSync('npm outdated', { cwd: ensureRoot(), stdio: 'inherit' });
    } catch {
      // npm outdated exits 1 when outdated packages exist
    }
  },

  async install() {
    const hookPath = resolve(GIT_HOOKS, 'pre-commit');
    const hookContent = `#!/bin/bash
cd "$(dirname "$0")/../.."
~/bin/kitchen check || exit 1
`;
    mkdirSync(GIT_HOOKS, { recursive: true });
    writeFileSync(hookPath, hookContent, { mode: 0o755 });
    console.log('✓ Pre-commit hook installed at .git/hooks/pre-commit');
  }
};
