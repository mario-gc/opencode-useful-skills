#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
SKILL_NAME="gha-act-workflows"
SKILL_CONTENT="$SKILL_DIR/$SKILL_NAME"
TARGET_DIR="$HOME/.config/opencode/skills"

if [ ! -d "$SKILL_CONTENT" ]; then
  echo "Error: Skill content folder not found: $SKILL_CONTENT"
  exit 1
fi

if [ ! -f "$SKILL_CONTENT/SKILL.md" ]; then
  echo "Error: SKILL.md not found in $SKILL_CONTENT"
  exit 1
fi

mkdir -p "$TARGET_DIR"
cp -r "$SKILL_CONTENT" "$TARGET_DIR/"

echo "Deployed $SKILL_NAME to $TARGET_DIR/$SKILL_NAME"