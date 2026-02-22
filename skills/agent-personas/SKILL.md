# Agent Personas

System prompts and behavioral guidelines for OpenClaw sub-agents.

## Usage

Prepend the appropriate persona to sub-agent task prompts for consistent behavior:

```typescript
// Read persona
const persona = read({ file_path: "~/.openclaw/skills/agent-personas/coder.md" });

// Prepend to task
const taskWithPersona = `${persona.content}\n\n## Task\n${actualTask}`;

// Spawn with persona
sessions_spawn({ task: taskWithPersona, label: "agent:coder" });
```

## Available Personas

| Persona | File | Use Case |
|---------|------|----------|
| Coder | `coder.md` | Code implementation, refactoring, tests |
| Researcher | `researcher.md` | Information gathering, analysis |
| Strategist | `strategist.md` | Architecture, planning, design |
| Reviewer | `reviewer.md` | Quality gates, reviews, critiques |

## Persona Structure

Each persona defines:
- **Core Identity:** Role and expertise
- **Behavioral Rules:** Non-negotiable constraints
- **Output Format:** Expected response structure
- **Forbidden:** Explicitly prohibited behaviors

## Integration with plan Skill

The plan skill automatically uses personas when spawning agents:

```typescript
// planWithReview() reads and prepends personas before spawning
strategistTask = readPersona('strategist') + originalTask
reviewerTask = readPersona('reviewer') + planContent
```
