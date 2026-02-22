# OpenClaw Extensions

A collection of skills and extensions for the OpenClaw AI assistant platform.

## Overview

This repository contains various skills that extend the capabilities of OpenClaw, including:

- **Agent personas** - Predefined agent roles and personas
- **Task orchestration** - Parallel execution and coordination of sub-agents
- **Planning systems** - Actor-Critic architecture for strategic planning
- **Integration skills** - External resource integration and intelligent process systems
- **Utility skills** - Kitchen maintenance and other utilities

## Skills Inventory

### Core Agent Skills
- **agent-personas** - Sub-agent personas for delegation and specialized tasks
- **task-orchestrator** - Parallel execution framework for concurrent sub-agent operations
- **plan** - Actor-Critic architecture for strategic planning and review
- **strategist** - Long-term planning and reflection capabilities

### Integration Skills
- **erid** - Executive Role Intelligence Dashboard — track CISO/VP security roles, executive search firms, applications, and career signals
- **ipis** - Intelligent process integration system

### Utility Skills
- **kitchen** - Kitchen management and maintenance utilities
- **kitchen-maint** - Extended kitchen maintenance capabilities

## Installation

Skills can be installed using the ClawHub CLI:

```bash
clawhub install <skill-name>
```

Or manually by copying the skill directory to `~/.openclaw/skills/`

## Usage

Each skill includes its own documentation. Refer to the individual skill directories for specific usage instructions.

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Author

Clinton Wanner