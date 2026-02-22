export function reportTest(output, passed) {
  if (passed) {
    const match = output.match(/Tests\s+(\d+)\s+passed/);
    console.log(`✓ Tests passed ${match ? `(${match[1]})` : ''}`);
    return;
  }
  
  const lines = output.split('\n');
  for (const line of lines) {
    if (line.includes('FAIL')) {
      console.log('✗ ' + line.trim());
    }
  }
}

export function reportLint(output) {
  const lines = output.split('\n');
  const errors = [];
  let current = null;
  
  for (const line of lines) {
    const match = line.match(/^(.+):(\d+):(\d+)\s+(error|warning)\s+(.+)$/);
    if (match) {
      const [, file, row, col, type, msg] = match;
      errors.push(`${file}:${row}  ${type}: ${msg}`);
    }
  }
  
  if (errors.length) {
    console.log('Lint errors:');
    errors.slice(0, 20).forEach(e => console.log('  ' + e));
    if (errors.length > 20) console.log(`  ...and ${errors.length - 20} more`);
  } else {
    console.log('✗ Lint failed');
    console.log(output.slice(0, 500));
  }
}

export function reportBuild() {
  console.log('✓ Build passed');
}
