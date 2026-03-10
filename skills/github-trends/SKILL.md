---
name: github-trends
description: Fetch and display GitHub trending repositories. Use when user asks about GitHub trends, popular repositories, or what's hot on GitHub today/this week/this month.
---

# GitHub Trends

Fetch trending repositories from GitHub with detailed information including descriptions, languages, and star counts.

## Quick Usage

```bash
# Run the script directly
./github-trends.sh

# Or with options
./github-trends.sh --since weekly --limit 15
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--since` | Time period: `daily`, `weekly`, `monthly` | `daily` |
| `--limit` | Number of repositories to show | `12` |
| `--lang` | Filter by language (e.g., `python`, `typescript`) | all |
| `--output` | Output format: `markdown`, `json`, `simple` | `markdown` |
| `--help` | Show help message | - |

## Examples

```bash
# Today's trending
./github-trends.sh

# This week's trending
./github-trends.sh --since weekly

# Top 20 Python repos this month
./github-trends.sh --since monthly --lang python --limit 20

# JSON output for programmatic use
./github-trends.sh --output json > trends.json
```

## Output Format

### Markdown (default)
```
📊 GitHub Trending (daily) - 2026-03-05
========================================

1. owner/repo-name
   📝 Repository description
   💻 Language: TypeScript
   ⭐ +1,234 stars today | 🍴 456 forks
   🔗 https://github.com/owner/repo-name
```

### JSON
```json
[
  {
    "name": "owner/repo",
    "description": "...",
    "language": "TypeScript",
    "stars_today": 1234,
    "forks": 456,
    "url": "https://github.com/owner/repo"
  }
]
```

## Response Guidance

When presenting results from this skill in chat or IM clients:

- Preserve the full result set and avoid dropping repositories or descriptions just to simplify formatting.
- Prefer short sections plus compact tables or bullet lists.
- If you use a Markdown table, keep it narrow: 3-4 columns max.
- Put long descriptions, commentary, and trend insights outside the table.
- Avoid very wide tables with long prose inside cells.
- Avoid horizontal rules like `---` unless the target surface clearly supports them.
- Preserve repository links inline.

Recommended presentation style:

```markdown
## 今日 GitHub 热门仓库

| 排名 | 仓库 | 今日新增 | 总星数 |
|------|------|---------|--------|
| 1 | [owner/repo](https://github.com/owner/repo) | +1,234 stars | 12,345 |
| 2 | [owner/repo-2](https://github.com/owner/repo-2) | +987 stars | 9,876 |

### 项目亮点

- [owner/repo](https://github.com/owner/repo)
  - Language: TypeScript
  - 描述: Repository description

- [owner/repo-2](https://github.com/owner/repo-2)
  - Language: Python
  - 描述: Another repository description
```

Important:

- For Feishu, Discord, and similar chat surfaces, compact tables are acceptable, but keep them simple and follow with bullets for details.
- Do not put long descriptions into table cells.
- If you summarize the raw tool output, keep all important repository metadata instead of compressing it away.

## Dependencies

- `curl` - HTTP requests
- `jq` - JSON parsing (optional, for better output)
- `awk`, `sed`, `grep` - Text processing

## API Notes

Uses GitHub's public trending page (HTML scraping) and GitHub API for repository details.
Rate limits apply: 60 requests/hour unauthenticated, 5000/hour with token.

To use authenticated requests, set `GITHUB_TOKEN` environment variable:
```bash
export GITHUB_TOKEN=your_token_here
./github-trends.sh
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Empty results | Check internet connection, GitHub may be rate limiting |
| Missing descriptions | Install `jq` for API-based details |
| Slow execution | Reduce `--limit` or use cached mode |
