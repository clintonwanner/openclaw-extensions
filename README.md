# OpenClaw Extensions

A collection of skills and extensions for the OpenClaw AI assistant platform.

## Overview

This repository contains various skills that extend the capabilities of OpenClaw, including:

- **Agent personas** - Predefined agent roles and personas
- **Task orchestration** - Parallel execution and coordination of sub-agents
- **Planning systems** - Actor-Critic architecture for strategic planning
- **Integration skills** - Google Workspace, n8n workflow automation, and more
- **Documentation tools** - Claw documentation generation and management
- **Utility skills** - Summarization, kitchen maintenance, and other utilities

## Skills Inventory

### Core Agent Skills
- **agent-personas** - Sub-agent personas for delegation and specialized tasks
- **task-orchestrator** - Parallel execution framework for concurrent sub-agent operations
- **plan** - Actor-Critic architecture for strategic planning and review
- **strategist** - Long-term planning and reflection capabilities

### Integration Skills
- **gog** - Google Workspace integration (Gmail, Calendar, Drive, Contacts, Sheets, Docs)
- **n8n-workflow-automation** - Integration with n8n workflow automation platform
- **erid** - External resource integration and data management
- **ipis** - Intelligent process integration system

### Documentation & Utility Skills
- **clawddocs** - Claw documentation generation and management
- **summarize** - Text summarization and analysis tools
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