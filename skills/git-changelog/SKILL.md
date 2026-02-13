---
name: git-changelog
description: Analyzes git commit history within a time range and generates a brief description of code changes. Use this skill when asked to summarize git history, generate changelog, describe what changed in a repo over a period, or review commit history. Handles large codebases by incrementally processing commits to avoid context window overflow.
---

# Git Changelog Generator

Generate concise summaries of git repository changes within a specified time range.

## Workflow

### Step 1: Clarify Time Range

If user doesn't specify, ask for:
- Start date (e.g., "2024-01-01", "1 week ago", "last month")
- End date (defaults to now)

### Step 2: Get Commit Overview

```bash
# Get commit list with stats (no full diff yet)
git log --oneline --since="<start>" --until="<end>" --stat
```

**Output analysis:**
- Total commit count
- Major files/directories changed
- Authors involved

### Step 2.5: Scan Related Documentation

> [!TIP]
> Technical docs and PRDs help understand the background and purpose of changes.

**Scan documentation in the repository:**

```bash
# Find relevant documentation
find . -maxdepth 3 -type f \( -name "*.md" -o -name "PRD*" -o -name "DESIGN*" \) \
  | grep -E "(docs/|README|PRD|DESIGN|CHANGELOG|Requirements|\.kiro/)" \
  | head -20
```

**Priority files to read:**
1. `.kiro/requirements.md` - Project requirements (if exists)
2. `docs/*.md` - Technical design documents
3. `**/README.md` - Project overview
4. `**/PRD*.md`, `**/DESIGN*.md` - Product and design documents
5. Recently modified `.md` files (within commit time range)

**Purpose:**
- Understand business context of changes
- Infer "why this change was needed"
- Reference documents in the final report

### Step 3: Incremental Commit Analysis

> [!IMPORTANT]
> **Context Window Management**: Process commits ONE AT A TIME. After analyzing each commit's diff, immediately summarize and DISCARD the raw diff. Never accumulate multiple diffs in context.

For each commit (oldest to newest):

```bash
# Get commit details with filtered diff
git show <sha> --stat --format="%h %s%n%b" -- \
  ':!*.lock' ':!*-lock.json' ':!*.sum' \
  ':!dist/*' ':!build/*' ':!*.min.*'
```

**Per-commit analysis:**
1. Read the `--stat` output first (file changes summary)
2. If needed, get partial diff: `git show <sha> -p -- <specific_files>`
3. Generate 1-2 sentence summary of THIS commit
4. **Discard the diff, keep only the summary**

**Skip patterns:**
- Lock files (`package-lock.json`, `go.sum`, etc.)
- Build artifacts (`dist/`, `build/`, `*.min.js`)
- Large generated files (>500 lines changed in single file)

### Step 4: Categorize Changes

Group commit summaries by type:
- **Features**: New functionality
- **Fixes**: Bug fixes
- **Refactoring**: Code improvements without behavior change
- **Docs**: Documentation updates
- **Deps**: Dependency updates
- **Tests**: Test additions/modifications

### Step 5: Generate Report-Style Summary

> [!IMPORTANT]
> Use "Problem → Solution → Impact" structure for each change. Do NOT just list bullet points.
> **Final output MUST be in Chinese.**

**Output format (report style, in Chinese):**

```markdown
## 代码改动报告：<start> 至 <end>

### 概述

<2-3 句话描述本次改动的整体方向和目标，可引用相关 PRD 或技术文档>

### Features（新功能）

#### <功能名称>

**时间**：<该改动的大致时间段，如 01-15 ~ 01-18>

**问题背景**：<为什么需要这个功能？业务需求是什么？可从 PRD/commit message 推断>

**解决方案**：<具体做了什么改动？涉及哪些关键文件和模块？>

**达到效果**：<这个改动带来了什么价值？用户/系统层面有什么改进？>

---

### Fixes（问题修复）

#### <修复标题>

**时间**：<该修复的大致时间段>

**问题背景**：<之前存在什么问题？用户遇到什么困难？>

**解决方案**：<如何修复的？改动了哪些代码？>

**达到效果**：<问题是否彻底解决？有无副作用？>

---

### Refactoring（代码重构）

#### <重构标题>

**时间**：<该重构的大致时间段>

**问题背景**：<原来的代码有什么问题？技术债是什么？>

**解决方案**：<重构了什么？架构如何调整？>

**达到效果**：<代码质量、可维护性、性能有何改善？>

---

### 其他改动

<文档更新、依赖升级、配置调整等可用列表简述>

### 统计

- **时间范围**: <start> 至 <end>
- **相关文档**: <引用的 PRD/技术文档列表>
```

**Writing guidelines:**

1. **Problem → Solution → Impact** - Use this structure for every significant change
2. **Reference docs** - If PRD/tech docs exist, cite them in the report
3. **Organize by type** - Features > Fixes > Refactoring > Others
4. **Narrative style** - Write like a tech weekly report, not dry bullet points

### Step 6: Save Report to File

> [!IMPORTANT]
> Always save the final report as a markdown file.

**Naming convention:**
```
changelog-<start>-to-<end>.md
```

Examples:
- `changelog-2024-01-01-to-2024-01-31.md`
- `changelog-last-week.md`

**Save location:**
- Default: repository root directory
- Or user-specified path

**After saving**, inform the user:
```
报告已保存至：<file_path>
```

## Context Compaction Strategies

When dealing with many commits:

1. **Batch by day/week**: If >20 commits, summarize by day first
2. **Focus on key files**: Prioritize changes in core code directories
3. **Merge similar commits**: Combine related small commits into single summary
4. **Progressive detail**: Start high-level, drill down only if user asks

## Example Usage

**User**: "帮我总结这个仓库过去一周的改动"

**Response flow**:
1. Run `git log --oneline --since="1 week ago" --stat`
2. Process each commit incrementally
3. Output categorized summary

## Edge Cases

- **Empty range**: Inform user no commits found
- **Too many commits (>100)**: Suggest narrowing time range or provide weekly summaries
- **Binary files**: Note presence but skip detailed analysis
- **Merge commits**: Focus on the merge summary, not re-analyzing merged commits
