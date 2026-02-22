---
name: kitchen
description: Testing and CI/CD workflows for the Kitchen App React project. Use when working with component tests, coverage reports, git commits, or GitHub Actions for the kitchen-app repository. Triggers for running tests (npm test, npm run test:run, npm run test:coverage), fixing test failures, adding new test coverage, or managing CI workflows.
---

# Kitchen App Testing Skill

## Project Location
`/app/.openclaw/workspace/kitchen-app`

## Testing Commands

```bash
cd /app/.openclaw/workspace/kitchen-app
npm test              # Watch mode
npm run test:run      # Run once, CI mode
npm run test:coverage # With coverage report
npm run lint          # ESLint check
```

## Coverage Target: 80%

**Current:** ~66% (quick check: `npm run test:coverage | grep "All files"`)

**Biggest gaps:**
- AdminModal.tsx - 0%
- MealPlanner.tsx - 0%
- KitchenTimer.tsx - 73%

## Test File Locations

```
src/components/__tests__/
├── AdminModal.test.tsx      # NEEDS TESTS (0% coverage)
├── MealPlanner.test.tsx     # NEEDS TESTS (0% coverage)
├── KitchenTimer.test.tsx    # Has tests, needs more
├── RecipeModal.test.tsx     # Good coverage (95%)
├── MealRoulette.test.tsx    # Full coverage (100%)
├── Dialog.test.tsx          # Full coverage (100%)
├── Toast.test.tsx           # Good coverage (97%)
├── ShoppingListModal.test.tsx # Good coverage
├── AddRecipeModal.test.tsx  # Good coverage
├── App.test.tsx             # Moderate coverage
├── regression.test.tsx      # Regression tests
└── accessibility.test.tsx   # Skipped for now
```

## Writing Tests: Pattern

Use this pattern for new tests:

```tsx
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ComponentName } from '../ComponentName';

describe('ComponentName Component', () => {
  const defaultProps = {
    prop1: 'value',
    onAction: vi.fn(),
  };

  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('renders correctly', () => {
    render(<ComponentName {...defaultProps} />);
    expect(screen.getByText('Expected Text')).toBeInTheDocument();
  });
});
```

## CI Requirements

**Must pass before commit:**
1. `npm run lint` - No errors/warnings
2. `npm run test:run` - All tests pass

**Commit message format:**
```
test: add AdminModal coverage
feat: implement recipe search
fix: resolve timer bug
perf: lazy load images
```

## Quick Tasks

**Check current coverage:**
```bash
cd /app/.openclaw/workspace/kitchen-app && npm run test:coverage 2>&1 | grep -A1 "^File"
```

**Find uncovered lines:**
```bash
cd /app/.openclaw/workspace/kitchen-app && npm run test:coverage 2>&1 | grep -E "(Admin|MealPlanner)
```

**Run specific test file:**
```bash
cd /app/.openclaw/workspace/kitchen-app && npm test -- AdminModal.test.tsx
```

## Git Workflow

```bash
# 1. Make changes
# 2. Run checks
cd /app/.openclaw/workspace/kitchen-app
npm run lint
npm run test:run

# 3. Bump version (REQUIRED for every push with code changes)
# Current version in package.json - increment patch (0.0.0 -> 0.0.1)
npm version patch --no-git-tag-version

# 4. Commit & push
git add -A
git commit -m "test: add ComponentName tests"
git push origin main
```

**Version Display:** The AdminModal shows `KitchenOS v{version}` from `/api/admin/version` API. The version is derived from `package.json` (pushed to GitHub) and the server must sync to match.

**Version Rules:**
- Every push with code changes: `npm version patch` (0.0.0 → 0.0.1)
- Breaking changes: `npm version minor` (0.0.1 → 0.1.0)
- Major releases: `npm version major` (0.1.0 → 1.0.0)

## Common Test Issues

| Issue | Fix |
|-------|-----|
