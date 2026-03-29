#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
TARGET_DIR="$HOME/.config/opencode/skills"

deployed=0
failed=0

for skill_dir in "$ROOT_DIR"/*-skill; do
  if [ -d "$skill_dir" ]; then
    skill_name=$(basename "$skill_dir" | sed 's/-skill$//')
    skill_content="$skill_dir/$skill_name"
    
    if [ -d "$skill_content" ]; then
      if [ -f "$skill_content/SKILL.md" ]; then
        mkdir -p "$TARGET_DIR"
        cp -r "$skill_content" "$TARGET_DIR/"
        echo "✓ Deployed: $skill_name"
        ((deployed++))
      else
        echo "✗ Missing SKILL.md: $skill_name"
        ((failed++))
      fi
    else
      echo "✗ Missing skill content folder: $skill_name"
      ((failed++))
    fi
  fi
done

echo ""
echo "Deployed: $deployed, Failed: $failed"

if [ $failed -gt 0 ]; then
  exit 1
fi