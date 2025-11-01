# Aug Plugin Marketplace - Development Tools

# Show all available commands
default:
    @just --list

# Token count report by file
tok:
    #!/usr/bin/env bash
    echo "Token count by file:"
    echo "===================="
    find dev util -name "*.md" -type f | while read -r file; do
        # Rough estimate: ~4 chars per token
        chars=$(wc -c < "$file")
        tokens=$((chars / 4))
        printf "%6d tokens  %s\n" "$tokens" "$file"
    done | sort -rn
    echo ""
    echo "Total:"
    total_chars=$(find dev util -name "*.md" -type f -exec cat {} + | wc -c)
    total_tokens=$((total_chars / 4))
    printf "%6d tokens (estimated)\n" "$total_tokens"

# Validate YAML frontmatter in skills and commands
lint:
    #!/usr/bin/env bash
    echo "Validating frontmatter..."
    exit_code=0

    find dev util -name "*.md" -type f | while read -r file; do
        # Skip CLAUDE.md and README.md files
        if [[ "$file" == */CLAUDE.md ]] || [[ "$file" == */README.md ]]; then
            continue
        fi

        # Check if file starts with ---
        if ! head -n 1 "$file" | grep -q "^---$"; then
            echo "❌ $file: Missing frontmatter"
            exit_code=1
            continue
        fi

        # Extract frontmatter (between first two --- lines)
        frontmatter=$(awk '/^---$/{i++}i==1{print}i==2{exit}' "$file" | sed '1d')

        # Check for required fields based on directory
        if [[ "$file" == */skills/* ]]; then
            # Skills should have: name, description
            if ! echo "$frontmatter" | grep -q "^name:"; then
                echo "❌ $file: Missing 'name' field"
                exit_code=1
            fi
            if ! echo "$frontmatter" | grep -q "^description:"; then
                echo "❌ $file: Missing 'description' field"
                exit_code=1
            fi
        elif [[ "$file" == */commands/* ]]; then
            # Commands should have: name, description
            if ! echo "$frontmatter" | grep -q "^name:"; then
                echo "❌ $file: Missing 'name' field"
                exit_code=1
            fi
            if ! echo "$frontmatter" | grep -q "^description:"; then
                echo "❌ $file: Missing 'description' field"
                exit_code=1
            fi
        fi
    done

    if [ $exit_code -eq 0 ]; then
        echo "✅ All frontmatter valid"
    fi
    exit $exit_code

# Validate marketplace.json and plugin.json files
valid:
    #!/usr/bin/env bash
    echo "Validating JSON manifests..."
    exit_code=0

    # Validate marketplace.json
    if [ -f ".claude-plugin/marketplace.json" ]; then
        if jq empty .claude-plugin/marketplace.json 2>/dev/null; then
            echo "✅ marketplace.json is valid JSON"
        else
            echo "❌ marketplace.json is invalid JSON"
            exit_code=1
        fi
    else
        echo "⚠️  marketplace.json not found"
    fi

    # Validate all plugin.json files
    find dev util -name "plugin.json" -type f | while read -r file; do
        if jq empty "$file" 2>/dev/null; then
            echo "✅ $file is valid JSON"
        else
            echo "❌ $file is invalid JSON"
            exit_code=1
        fi
    done

    exit $exit_code

# Validate cross-references between skills and commands
refs:
    #!/usr/bin/env bash
    echo "Validating references..."
    exit_code=0

    # Find all skill and command files
    skills=$(find dev util -path "*/skills/*.md" -type f)
    commands=$(find dev util -path "*/commands/*.md" -type f)

    # Check for references to non-existent skills/commands
    find dev util -name "*.md" -type f | while read -r file; do
        # Look for skill references (skill:name-format)
        grep -o 'skill:[a-z-]*' "$file" 2>/dev/null | while read -r ref; do
            skill_name=$(echo "$ref" | cut -d: -f2)
            if ! echo "$skills" | grep -q "/${skill_name}.md$"; then
                echo "⚠️  $file: Reference to missing skill '$skill_name'"
            fi
        done

        # Look for command references (command:name-format or /name-format)
        grep -Eo '(command:[a-z-]+|/[a-z-]+)' "$file" 2>/dev/null | while read -r ref; do
            if [[ "$ref" == //* ]]; then
                cmd_name=$(echo "$ref" | sed 's|^/||')
            else
                cmd_name=$(echo "$ref" | cut -d: -f2)
            fi

            # Skip common false positives
            if [[ "$cmd_name" =~ ^(help|clear|plugin)$ ]]; then
                continue
            fi

            if ! echo "$commands" | grep -q "/${cmd_name}.md$"; then
                echo "⚠️  $file: Reference to missing command '$cmd_name'"
            fi
        done
    done

    echo "✅ Reference validation complete"

# Analyze skills/commands for anti-patterns (requires claude CLI)
analyze:
    #!/usr/bin/env bash
    if ! command -v claude &> /dev/null; then
        echo "❌ claude CLI not found. Install from: https://github.com/anthropics/claude-cli"
        exit 1
    fi

    echo "Analyzing skills and commands for anti-patterns..."
    echo ""

    find dev util -path "*/skills/*.md" -o -path "*/commands/*.md" | while read -r file; do
        echo "Analyzing: $file"
        claude -p "Analyze this Claude Code skill/command for anti-patterns: YAGNI violations, token waste, boundary violations (skills acting like commands), procedural content in skills. Be concise. List only actual problems found. File: $file" < "$file"
        echo ""
        echo "---"
        echo ""
    done

# Validate a justfile against v2 interface spec
validate-justfile JUSTFILE:
    @bash dev/skills/justfile-standard-interface/scripts/validate-justfile.sh "{{JUSTFILE}}"

# Clean generated artifacts
clean:
    @echo "Nothing to clean yet"
