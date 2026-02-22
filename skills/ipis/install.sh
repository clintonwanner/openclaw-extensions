#!/bin/bash
# IPIS Skill Installation Script

echo "Installing IPIS (Interview Performance Intelligence System) Skill..."
echo ""

# Check if OpenClaw skills directory exists
if [ ! -d "$HOME/.openclaw/skills" ]; then
    echo "Creating OpenClaw skills directory..."
    mkdir -p "$HOME/.openclaw/skills"
fi

# Copy skill to skills directory
SKILL_DIR="$HOME/.openclaw/skills/ipis"
if [ -d "$SKILL_DIR" ]; then
    echo "Updating existing IPIS skill..."
else
    echo "Installing new IPIS skill..."
fi

# Create symlink for CLI command
BIN_DIR="$HOME/.local/bin"
if [ ! -d "$BIN_DIR" ]; then
    mkdir -p "$BIN_DIR"
fi

# Create ipis command
cat > "$BIN_DIR/ipis" << 'EOF'
#!/bin/bash
"$HOME/.openclaw/skills/ipis/ipis.sh" "$@"
EOF

chmod +x "$BIN_DIR/ipis"

echo ""
echo "✅ IPIS skill installed successfully!"
echo ""
echo "Available commands:"
echo "  ipis init     - Initialize database"
echo "  ipis debrief  - Start post-interview capture"
echo "  ipis pattern  - Show common patterns/trends"
echo "  ipis thankyou - Mark thank-you as sent"
echo "  ipis stats    - Interview performance summary"
echo "  ipis help     - Show help"
echo ""
echo "Quick start:"
echo "  1. Run 'ipis init' to create database"
echo "  2. After an interview, run 'ipis debrief'"
echo "  3. Review patterns with 'ipis pattern'"
echo ""
echo "Documentation: $HOME/.openclaw/skills/ipis/README.md"