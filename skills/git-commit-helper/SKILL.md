---
name: git-commit-helper
description: Handles git commit workflow by analyzing code changes, generating concise commit messages.
---

# Git Commit Helper

This skill analyzes code changes and helps create git commits with concise, AI-generated commit messages.

## Workflow

### Step 1: Gather Context

Run these commands in parallel to understand the changes:

```bash
git status
git diff
git diff --staged
git log -5 --oneline
```

### Step 2: Analyze Changes Deeply

Analyze the git diff output to understand the actual code changes:

**Key Analysis Points:**

- **Function/method changes**: Look for added, removed, or modified functions
- **Logic changes**: Identify changes in conditional logic, loops, or control flow
- **API changes**: Note changes in function signatures, parameters, or return values
- **Data structure changes**: Look for changes in types, interfaces, or data models
- **Configuration changes**: Identify changes in config files, environment variables
- **Dependency changes**: Note additions, removals, or version updates in package files
- **Test changes**: Look for new tests, modified assertions, or test coverage changes

**Analysis Strategy:**

1. Read the diff output carefully - focus on the actual code changes, not just file names
2. Identify the semantic meaning of changes (e.g., "added error handling" vs "changed line 42")
3. Look for patterns that indicate the type of change (bug fix, feature, refactor, etc.)
4. Consider the impact of changes on the codebase

### Step 3: Generate Commit Message

Based on your deep analysis, generate a concise, single-line commit message following this format:

```
<type>: <brief description>
```

**IMPORTANT:** The commit message MUST strictly follow this format:

- Must contain exactly one colon (`:`) separating type and description
- Type must be one of the valid types listed below
- There must be a space after the colon
- Description must be present and non-empty
- No additional colons in the description

**Validation:** Before presenting to user, verify the message matches the pattern `^[a-z]+: .+$`. If it doesn't match, regenerate until it does.

**Types:**

- `fix` - Bug fixes
- `feat` - New features
- `refactor` - Code refactoring
- `docs` - Documentation changes
- `style` - Code style/formatting changes
- `test` - Test additions or modifications
- `chore` - Maintenance tasks, dependency updates
- `perf` - Performance improvements

**Examples:**

- `fix: resolve login authentication bug`
- `feat: add user profile page`
- `refactor: simplify database query logic`
- `test: add unit tests for auth module`
- `fix: handle null pointer exception in data parser`
- `feat: implement rate limiting for API endpoints`
- `refactor: extract validation logic into separate module`
- `fix: correct timezone handling in date calculations`

**Invalid examples (do NOT use):**

- `Fix login bug` (missing type prefix)
- `fix login bug` (missing colon)
- `fix:login bug` (missing space after colon)
- `fix:` (missing description)
- `fix: resolve: login bug` (extra colon in description)
- `fix: update file` (too vague, doesn't describe what changed)

### Step 4: Present to User for Confirmation

**IMPORTANT:** Use the `AskUserQuestion` tool to present the commit message to the user with interactive options.

Ask the user:

```
Proposed commit message: <your generated message>

Do you want to proceed with this commit message?
```

Options:

- "Accept" - Use the message as-is
- "Modify" - User wants to edit the message
- "Cancel" - Abort the commit

Example using AskUserQuestion:

- Header: "Commit"
- Question: "Proposed commit message: fix: resolve login authentication bug. Do you want to proceed?"
- Options:
  - "Accept" - Use this commit message
  - "Modify" - I want to edit the message
  - "Cancel" - Abort the commit

If user selects "Modify", ask them to provide the new message, then proceed to Step 5.
If user selects "Cancel", inform them the commit was aborted and stop.
If user selects "Accept", proceed to Step 5.

### Step 5: Execute Commit

Once confirmed, run the git commands:

```bash
# Stage all changed files (if not already staged)
git add .

# Create commit with user-approved message
git commit -m "fix: resolve login authentication bug"

# Verify success
git status
git log -1
```

## Guidelines

- Keep commit messages to one line, under 72 characters
- Use imperative mood ("fix" not "fixed", "add" not "added")
- Focus on WHAT changed, not WHY (the WHY should be in code comments)
- Be specific but concise
- If multiple unrelated changes exist, ask user to create separate commits

## Edge Cases

- **No changes detected**: Inform the user there are no changes to commit
- **Only staged changes**: Work with staged changes, don't re-stage
- **Mixed staged/unstaged**: Ask user if they want to stage all or work selectively
- **Merge conflicts**: Resolve conflicts before attempting commit
- **No changes to commit**: Check `.gitignore` - files might be ignored
