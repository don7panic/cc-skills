#!/bin/bash
#
# GitHub Trending Fetcher
# Fetches trending repositories from GitHub with detailed information
#
# Usage: ./github-trends.sh [options]
#

set -e

# Default values
SINCE="daily"
LIMIT=12
LANG=""
OUTPUT="markdown"

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Help message
show_help() {
    cat << EOF
GitHub Trending Fetcher

Usage: $(basename "$0") [options]

Options:
    --since <period>    Time period: daily, weekly, monthly (default: daily)
    --limit <number>    Number of repositories to show (default: 12)
    --lang <language>   Filter by programming language (default: all)
    --output <format>   Output format: markdown, json, simple (default: markdown)
    --help              Show this help message

Examples:
    $(basename "$0")                              # Today's trending
    $(basename "$0") --since weekly               # This week's trending
    $(basename "$0") --lang python --limit 20     # Top 20 Python repos
    $(basename "$0") --output json > trends.json  # JSON output

Environment:
    GITHUB_TOKEN    GitHub personal access token (optional, increases rate limit)

EOF
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --since)
            SINCE="$2"
            shift 2
            ;;
        --limit)
            LIMIT="$2"
            shift 2
            ;;
        --lang)
            LANG="$2"
            shift 2
            ;;
        --output)
            OUTPUT="$2"
            shift 2
            ;;
        --help|-h)
            show_help
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            ;;
    esac
done

# Validate since parameter
case $SINCE in
    daily|weekly|monthly) ;;
    *)
        echo "Error: --since must be daily, weekly, or monthly"
        exit 1
        ;;
esac

# Check dependencies
if ! command -v curl &> /dev/null; then
    echo "Error: curl is required but not installed"
    exit 1
fi

# Build GitHub trending URL
build_url() {
    local base_url="https://github.com/trending"
    if [[ -n "$LANG" ]]; then
        base_url="$base_url/$LANG"
    fi
    echo "${base_url}?since=${SINCE}"
}

# Fetch trending repositories from HTML
fetch_trending_html() {
    local url
    url=$(build_url)
    
    curl -sS "$url" 2>/dev/null
}

# Parse repository names from HTML
parse_repos() {
    local html="$1"
    
    echo "$html" | grep -o 'href="/[a-zA-Z0-9_.-]*/[a-zA-Z0-9_.-]*"' \
        | head -"$((LIMIT * 3))" \
        | sort -u \
        | grep -v -E '^href="/(sponsors|apps|trending|site|about|pricing|contact|features|security|explore)' \
        | sed 's/href="//;s/"$//' \
        | sed 's/^\///' \
        | head -"$LIMIT"
}

# Parse stars from HTML
parse_stars() {
    local html="$1"
    
    echo "$html" | grep -o '[0-9,]* stars today\|[0-9,]* stars this week\|[0-9,]* stars this month' \
        | head -"$LIMIT"
}

# Get repository details from API
get_repo_details() {
    local repo="$1"
    local api_url="https://api.github.com/repos/$repo"
    local auth_header=""
    
    # Add auth header if token is available
    if [[ -n "$GITHUB_TOKEN" ]]; then
        auth_header="-H \"Authorization: token $GITHUB_TOKEN\""
    fi
    
    if command -v jq &> /dev/null; then
        curl -sS $auth_header "$api_url" 2>/dev/null
    else
        # Fallback without jq
        curl -sS $auth_header "$api_url" 2>/dev/null
    fi
}

# Format output as markdown
format_markdown() {
    local repo="$1"
    local desc="$2"
    local lang="$3"
    local stars_today="$4"
    local stars_total="$5"
    local forks="$6"
    local url="https://github.com/$repo"
    
    cat << EOF
📦 $repo
   📝 $desc
   💻 Language: $lang | ⭐ $stars_total total | 🍴 $forks forks
   🔥 +$stars_today stars $SINCE_TEXT
   🔗 $url

EOF
}

# Format output as simple text
format_simple() {
    local repo="$1"
    local desc="$2"
    local lang="$3"
    local stars_today="$4"
    
    echo "$repo | +$stars_today stars | $lang | $desc"
}

# Format output as JSON
format_json() {
    local repo="$1"
    local desc="$2"
    local lang="$3"
    local stars_today="$4"
    local stars_total="$5"
    local forks="$6"
    
    cat << EOF
  {
    "name": "$repo",
    "description": "$desc",
    "language": "$lang",
    "stars_today": $stars_today,
    "stars_total": $stars_total,
    "forks": $forks,
    "url": "https://github.com/$repo"
  }
EOF
}

# Main function
main() {
    local since_text
    case $SINCE in
        daily)   since_text="today" ;;
        weekly)  since_text="this week" ;;
        monthly) since_text="this month" ;;
    esac
    
    local date_str
    date_str=$(date +%Y-%m-%d)
    
    # Fetch HTML
    local html
    html=$(fetch_trending_html)
    
    if [[ -z "$html" ]]; then
        echo "Error: Failed to fetch GitHub trending page"
        exit 1
    fi
    
    # Parse repositories
    local repos
    repos=$(parse_repos "$html")
    
    if [[ -z "$repos" ]]; then
        echo "Error: No repositories found"
        exit 1
    fi
    
    # Parse stars
    local stars_arr=()
    while IFS= read -r line; do
        stars_arr+=("$line")
    done < <(parse_stars "$html")
    
    # Output header
    if [[ "$OUTPUT" == "markdown" ]]; then
        echo "📊 GitHub Trending ($SINCE) - $date_str"
        echo "========================================"
        echo ""
    elif [[ "$OUTPUT" == "json" ]]; then
        echo "["
    fi
    
    local count=0
    local json_comma=""
    
    # Process each repository
    while IFS= read -r repo; do
        count=$((count + 1))
        
        # Get stars from HTML (fallback)
        local stars_today=""
        if [[ $count -le ${#stars_arr[@]} ]]; then
            stars_today="${stars_arr[$((count-1))]}"
            stars_today=$(echo "$stars_today" | grep -o '[0-9,]*' | tr -d ',')
        fi
        
        # Get details from API
        local desc="No description"
        local lang="N/A"
        local stars_total="0"
        local forks="0"
        
        if command -v jq &> /dev/null; then
            local details
            details=$(get_repo_details "$repo")
            
            if [[ -n "$details" ]]; then
                desc=$(echo "$details" | jq -r '.description // "No description"' | sed 's/"/\\"/g')
                lang=$(echo "$details" | jq -r '.language // "N/A"')
                stars_total=$(echo "$details" | jq -r '.stargazers_count // 0')
                forks=$(echo "$details" | jq -r '.forks_count // 0')
            fi
        fi
        
        # Default stars_today if empty
        if [[ -z "$stars_today" ]]; then
            stars_today="0"
        fi
        
        # Output based on format
        case $OUTPUT in
            markdown)
                format_markdown "$repo" "$desc" "$lang" "$stars_today" "$stars_total" "$forks"
                ;;
            simple)
                format_simple "$repo" "$desc" "$lang" "$stars_today"
                ;;
            json)
                if [[ $count -gt 1 ]]; then
                    echo ","
                fi
                format_json "$repo" "$desc" "$lang" "$stars_today" "$stars_total" "$forks"
                ;;
        esac
        
    done <<< "$repos"
    
    # Close JSON array
    if [[ "$OUTPUT" == "json" ]]; then
        echo ""
        echo "]"
    fi
}

# Run main
main
