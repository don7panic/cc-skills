#!/bin/bash

# Claude Code Skills Installer
# This script installs skills from the current repository to Claude Code's skills directory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE_DIR="$SCRIPT_DIR/skills"

# Claude Code skills directory
CLAUDE_SKILLS_DIR="$HOME/.claude/skills"

echo -e "${GREEN}Claude Code Skills Installer${NC}"
echo "================================"
echo ""

# Check if skills directory exists
if [ ! -d "$SKILLS_SOURCE_DIR" ]; then
    echo -e "${RED}Error: Skills directory not found at $SKILLS_SOURCE_DIR${NC}"
    exit 1
fi

# Check if Claude skills directory exists, create if not
if [ ! -d "$CLAUDE_SKILLS_DIR" ]; then
    echo -e "${YELLOW}Creating Claude skills directory at $CLAUDE_SKILLS_DIR${NC}"
    mkdir -p "$CLAUDE_SKILLS_DIR"
fi

# Find all skill directories
SKILL_COUNT=0
for skill_dir in "$SKILLS_SOURCE_DIR"/*/; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        skill_dest="$CLAUDE_SKILLS_DIR/$skill_name"

        echo -e "${GREEN}Installing skill: $skill_name${NC}"

        # Remove existing skill directory if it exists
        if [ -d "$skill_dest" ]; then
            echo -e "${YELLOW}  Removing existing installation...${NC}"
            rm -rf "$skill_dest"
        fi

        # Copy skill directory
        cp -r "$skill_dir" "$skill_dest"
        echo -e "${GREEN}  Installed to: $skill_dest${NC}"

        ((SKILL_COUNT++))
    fi
done

echo ""
if [ $SKILL_COUNT -eq 0 ]; then
    echo -e "${YELLOW}No skills found in $SKILLS_SOURCE_DIR${NC}"
else
    echo -e "${GREEN}Successfully installed $SKILL_COUNT skill(s)!${NC}"
    echo ""
    echo "You can now use these skills in Claude Code."
fi
