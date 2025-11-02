#!/usr/bin/env bash
# Validate justfile against v2 interface specification

set -euo pipefail

JUSTFILE="${1:?Usage: $0 <path-to-justfile>}"

if [ ! -f "$JUSTFILE" ]; then
    echo "❌ File not found: $JUSTFILE"
    exit 1
fi

# Required commands with exact comment strings
declare -A REQUIRED_COMMANDS=(
    ["default"]="Show all available commands"
    ["dev-install"]="Install dependencies and setup development environment"
    ["format"]="Format code (auto-fix)"
    ["lint"]="Lint code (auto-fix, complexity threshold=10)"
    ["typecheck"]="Type check code"
    ["test"]="Run unit tests"
    ["test-watch"]="Run tests in watch mode"
    ["coverage"]="Run unit tests with coverage threshold (96%)"
    ["integration-test"]="Run integration tests with coverage report (no threshold)"
    ["complexity"]="Detailed complexity report for refactoring decisions"
    ["loc"]="Show N largest files by lines of code"
    ["deps"]="Show outdated packages"
    ["vulns"]="Check for security vulnerabilities"
    ["lic"]="Analyze licenses (flag GPL, etc.)"
    ["sbom"]="Generate software bill of materials"
    ["build"]="Build artifacts"
    ["check-all"]="Run all quality checks (format, lint, typecheck, coverage - fastest first)"
    ["clean"]="Remove generated files and artifacts"
)

echo "Validating justfile: $JUSTFILE"
echo "================================"
echo ""

exit_code=0

# Check for required commands
for cmd in "${!REQUIRED_COMMANDS[@]}"; do
    comment="${REQUIRED_COMMANDS[$cmd]}"

    # Look for command definition
    if ! grep -q "^${cmd}:" "$JUSTFILE" && ! grep -q "^${cmd} " "$JUSTFILE"; then
        echo "❌ Missing command: $cmd"
        exit_code=1
        continue
    fi

    # Check if comment matches (look for comment line before command)
    # Extract comment for this command
    found_comment=$(awk "/^# .*$/ { comment=\$0; getline; if (\$0 ~ /^${cmd}[:( ]/) print comment }" "$JUSTFILE" | sed 's/^# //')

    if [ -z "$found_comment" ]; then
        echo "⚠️  $cmd: Missing comment"
        exit_code=1
    elif [ "$found_comment" != "$comment" ]; then
        echo "⚠️  $cmd: Comment mismatch"
        echo "   Expected: $comment"
        echo "   Found:    $found_comment"
        exit_code=1
    else
        echo "✅ $cmd"
    fi
done

echo ""

# Check check-all dependencies
if grep -q "^check-all:" "$JUSTFILE"; then
    check_all_line=$(grep "^check-all:" "$JUSTFILE")

    if [[ "$check_all_line" =~ format.*lint.*typecheck.*coverage ]]; then
        echo "✅ check-all has correct order: format → lint → typecheck → coverage"
    else
        echo "❌ check-all must have dependencies in order: format lint typecheck coverage"
        exit_code=1
    fi
fi

echo ""

if [ $exit_code -eq 0 ]; then
    echo "✅ Justfile is valid!"
else
    echo "❌ Justfile validation failed"
fi

exit $exit_code
