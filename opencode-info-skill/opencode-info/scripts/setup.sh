#!/bin/bash

REPO_DIR="/tmp/opencode-repo"
OPENCODE_REPO="https://github.com/anomalyco/opencode.git"
DOCS_PATH="packages/web/src/content/docs"
SRC_PATH="packages/opencode/src"
HASH_FILE="$REPO_DIR/.opencode-docs-hash"
INDEX_FILE="$REPO_DIR/.opencode-docs-index.json"

clone_repo() {
  echo "Cloning opencode repo (sparse, shallow)..."
  git clone --depth=1 --filter=blob:none --sparse \
    "$OPENCODE_REPO" "$REPO_DIR"
  
  cd "$REPO_DIR"
  git sparse-checkout set "$DOCS_PATH" "$SRC_PATH"
  
  CURRENT_HASH=$(git rev-parse HEAD)
  echo "$CURRENT_HASH" > "$HASH_FILE"
}

update_check() {
  cd "$REPO_DIR"
  
  STORED_HASH=$(cat "$HASH_FILE" 2>/dev/null || echo "")
  REMOTE_HASH=$(git ls-remote origin HEAD 2>/dev/null | cut -f1)
  
  if [ -z "$REMOTE_HASH" ]; then
    echo "Warning: Could not fetch remote hash"
    return 1
  fi
  
  if [ "$STORED_HASH" != "$REMOTE_HASH" ]; then
    echo "Docs are stale. Updating..."
    git pull
    echo "$REMOTE_HASH" > "$HASH_FILE"
    return 0
  fi
  
  echo "Docs are fresh (hash: $STORED_HASH)"
  return 1
}

generate_index() {
  echo "Generating docs index..."
  
  DOCS_DIR="$REPO_DIR/$DOCS_PATH"
  
  if [ ! -d "$DOCS_DIR" ]; then
    echo "Error: Docs directory not found: $DOCS_DIR"
    exit 1
  fi
  
  CURRENT_HASH=$(cat "$HASH_FILE" 2>/dev/null || git rev-parse HEAD)
  GENERATED_AT=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  
  echo "{" > "$INDEX_FILE"
  echo "  \"commitHash\": \"$CURRENT_HASH\"," >> "$INDEX_FILE"
  echo "  \"generatedAt\": \"$GENERATED_AT\"," >> "$INDEX_FILE"
  echo "  \"docs\": [" >> "$INDEX_FILE"
  
  first=true
  for mdx_file in "$DOCS_DIR"/*.mdx; do
    if [ -f "$mdx_file" ]; then
      filename=$(basename "$mdx_file")
      filepath="$mdx_file"
      
      title=""
      description=""
      
      if head -20 "$mdx_file" | grep -q "^---"; then
        title=$(head -20 "$mdx_file" | grep "^title:" | head -1 | sed 's/^title: *//' | sed 's/^"//' | sed 's/"$//')
        description=$(head -20 "$mdx_file" | grep "^description:" | head -1 | sed 's/^description: *//' | sed 's/^"//' | sed 's/"$//')
      fi
      
      if [ -z "$title" ]; then
        title=$(basename "$mdx_file" .mdx)
      fi
      
      if [ -z "$description" ]; then
        description="OpenCode documentation"
      fi
      
      if [ "$first" = true ]; then
        first=false
      else
        echo "," >> "$INDEX_FILE"
      fi
      
      printf "    {\n" >> "$INDEX_FILE"
      printf "      \"file\": \"%s\",\n" "$filename" >> "$INDEX_FILE"
      printf "      \"path\": \"%s\",\n" "$filepath" >> "$INDEX_FILE"
      printf "      \"title\": \"%s\",\n" "$title" >> "$INDEX_FILE"
      printf "      \"description\": \"%s\"\n" "$description" >> "$INDEX_FILE"
      printf "    }" >> "$INDEX_FILE"
    fi
  done
  
  echo "" >> "$INDEX_FILE"
  echo "  ]" >> "$INDEX_FILE"
  echo "}" >> "$INDEX_FILE"
  
  echo "Index generated: $INDEX_FILE"
  doc_count=$(grep -c '"file":' "$INDEX_FILE" 2>/dev/null || echo "0")
  echo "Docs indexed: $doc_count"
}

main() {
  if [ ! -d "$REPO_DIR" ]; then
    clone_repo
    generate_index
    echo "Setup complete."
  else
    echo "Repo exists at $REPO_DIR"
    if update_check; then
      generate_index
      echo "Update complete."
    else
      if [ ! -f "$INDEX_FILE" ]; then
        generate_index
        echo "Index generated."
      fi
    fi
  fi
}

main