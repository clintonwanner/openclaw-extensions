# OpenClaw Custom Skills Inventory

**Inventory Date:** 2026-02-22  
**Author:** Clinton Wanner  
**Purpose:** Complete inventory of all custom OpenClaw skills for GitHub repository 'openclaw-extensions'

---

## Summary

| Total Unique Skills | 8 |
| Total Files | 71 |
| Total Size | ~350KB |
| Locations Scanned | 3 |
| PII/Sanitization Flags | 0 |

**Locations Scanned:**
1. `~/.openclaw/skills/` - Main skills directory
2. `/app/workspace/skills/` - Workspace skills  
3. `/app/workspace/openclaw_config/skills/` - Config skills

---

## Skill Inventory

### 1. ERID (Executive Role Intelligence Dashboard)
**Description:** Executive Role Intelligence Dashboard — track CISO/VP security roles, executive search firms, applications, and career signals

**Locations:**
1. `~/.openclaw/skills/erid/`
2. `/app/workspace/skills/erid/`
3. `/app/workspace/openclaw_config/skills/erid/`

**Files:**
| File | Size (bytes) | Location | Author | PII/Sanitization |
|------|--------------|----------|--------|------------------|
| SKILL.md | 7,322 | All locations | Clinton Wanner | None |
| README.md | 1,295 | All locations | Clinton Wanner | None |
| REVIEW.md | 2,780 | ~/.openclaw, config | Clinton Wanner | None |
| schema.sql | 14,367 | All locations | Clinton Wanner | None |
| templates/weekly-report.md | 8,871 | All locations | Clinton Wanner | None |
| templates/interview-debrief.md | 7,431 | All locations | Clinton Wanner | None |
| templates/outreach-email.md | 5,252 | All locations | Clinton Wanner | None |

**Sanitization Check:** ✅ No PII found. All templates use placeholders ({{VARIABLE_NAME}}). No personal emails, phone numbers, or company-specific data.

---

### 2. IPIS (Interview Performance Intelligence System)
**Description:** Interview Performance Intelligence System — track debriefs, identify patterns, improve performance

**Locations:**
1. `~/.openclaw/skills/ipis/`
2. `/app/workspace/openclaw_config/skills/ipis/`

**Files:**
| File | Size (bytes) | Location | Author | PII/Sanitization |
|------|--------------|----------|--------|------------------|
| SKILL.md | 1,470 | Both locations | Clinton Wanner | None |
| README.md | 7,874 | Both locations | Clinton Wanner | None |
| schema.sql | 3,974 | Both locations | Clinton Wanner | None |
| test.sh | 2,934 | Both locations | Clinton Wanner | None |
| install.sh | 1,379 | Both locations | Clinton Wanner | None |
| ipis.sh | 7,060 | Both locations | Clinton Wanner | None |
| templates/debrief-template.md | 2,639 | Both locations | Clinton Wanner | None |

**Sanitization Check:** ✅ No PII found. All templates use placeholders. No personal data.

---

### 3. Task Orchestrator
**Description:** Task orchestration with verification gates, compaction scheduling, and session guards

**Locations:**
1. `~/.openclaw/skills/task-orchestrator/` (Legacy version)
2. `/app/workspace/skills/task-orchestrator/` (Enhanced version)
3. `/app/workspace/openclaw_config/skills/task-orchestrator/` (Legacy version)

**Files (Legacy Version):**
| File | Size (bytes) | Location | Author | PII/Sanitization |
|------|--------------|----------|--------|------------------|
| SKILL.md | 6,537 | ~/.openclaw, config | Clinton Wanner | None |
| tool_def.json | 1,419 | ~/.openclaw, config | Clinton Wanner | None |
| orchestrator.py.legacy | 1,769 | ~/.openclaw, config | Clinton Wanner | None |

**Files (Enhanced Version - /app/workspace/skills/task-orchestrator/):**
| File | Size (bytes) | Location | Author | PII/Sanitization |
|------|--------------|----------|--------|------------------|
| SKILL.md | 1,716 | workspace | Clinton Wanner | None |
| verification-gate.ts | 4,642 | workspace | Clinton Wanner | None |
| compaction-scheduler.ts | 3,488 | workspace | Clinton Wanner | None |
| session-guard.ts | 3,584 | workspace | Clinton Wanner | None |
| gateway-health.ts | 3,028 | workspace | Clinton Wanner | None |

**Sanitization Check:** ✅ No PII found. All code is generic implementation.

---

### 4. Plan (Actor-Critic Planning Skill)
**Description:** Actor-Critic architecture for iterative plan refinement with reviewer feedback

**Locations:**
1. `~/.openclaw/skills/plan/`
2. `/app/workspace/openclaw_config/skills/plan/`

**Files:**
| File | Size (bytes) | Location | Author | PII/Sanitization |
|------|--------------|----------|--------|------------------|
| SKILL.md | 7,379 | Both locations | Clinton Wanner | None |

**Sanitization Check:** ✅ No PII found.

---

### 5. Agent Personas
**Description:** System prompts and behavioral guidelines for OpenClaw sub-agents

**Locations:**
1. `~/.openclaw/skills/agent-personas/`
2. `/app/workspace/openclaw_config/skills/agent-personas/`

**Files:**
| File | Size (bytes) | Location | Author | PII/Sanitization |
|------|--------------|----------|--------|------------------|
| SKILL.md | 1,349 | Both locations | Clinton Wanner | None |
| coder.md | 2,196 | Both locations | Clinton Wanner | None |
| researcher.md | 1,690 | Both locations | Clinton Wanner | None |
| strategist.md | 1,866 | Both locations | Clinton Wanner | None |
| reviewer.md | 2,072 | Both locations | Clinton Wanner | None |

**Sanitization Check:** ✅ No PII found. All personas are generic system prompts.

---

### 6. Strategist (Reflection-to-Action Bridge)
**Description:** Strategist skill containing reflection and planning capabilities with R2A bridge

**Locations:**
1. `/app/workspace/skills/strategist/`

**Files:**
| File | Size (bytes) | Location | Author | PII/Sanitization |
|------|--------------|----------|--------|------------------|
| SKILL.md | 1,187 | workspace | Clinton Wanner | None |
| reflection-action-bridge.ts | 7,377 | workspace | Clinton Wanner | None |

**Sanitization Check:** ✅ No PII found. Code implements generic R2A bridge.

---

