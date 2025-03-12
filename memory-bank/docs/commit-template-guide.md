# Git Commit Message Template Guide

This guide explains how to use the custom commit message template with GitHub Copilot integration.

## Features

- Conventional commit types with emojis
- Categorized bullet points for changes
- Automatic template insertion
- Real-time format validation
- Completion suggestions for commit types

## Commit Message Format

```
type(scope): 🎯 Brief description (≤50 chars)

Technical:
  • 🔧 Implementation detail (≤72 chars)
User Impact:
  • 💡 User-facing change (≤72 chars)
Performance:
  • ⚡ Performance impact (≤72 chars)

-JMB
```

## Available Commands

| Command | Keybinding | Description |
|---------|------------|-------------|
| `<leader>cm` | - | Insert commit template |
| `<leader>cv` | - | Validate commit message |
| `:CopilotCommitTemplate` | - | Insert template |
| `:CopilotValidateCommit` | - | Validate message |

## Conventional Commit Types

| Type | Emoji | Usage |
|------|-------|-------|
| feat | ✨ | New features |
| fix | 🐛 | Bug fixes |
| docs | 📝 | Documentation |
| style | 💄 | Code style |
| refactor | ♻️ | Refactoring |
| test | ✅ | Testing |
| chore | 🔧 | Maintenance |

## Category Emojis

### Technical Changes
- 🔧 Infrastructure changes
- 🛠️ Implementation details
- ⚙️ System modifications

### User Impact
- 💡 User experience
- 👥 User interface
- 🎯 User workflow

### Performance
- ⚡ Speed improvements
- 🚀 Optimizations
- 📊 Metrics

## Example Messages

### Feature Addition
```
feat(auth): ✨ Add OAuth2 authentication support

Technical:
  • 🔧 Implement OAuth2 client configuration
  • 🛠️ Add token refresh mechanism
User Impact:
  • 💡 Add social login options

-JMB
```

### Bug Fix
```
fix(api): 🐛 Resolve rate limiting issue

Technical:
  • 🔧 Implement request throttling
Performance:
  • ⚡ Optimize request handling
  • 🚀 Add request caching

-JMB
```

### Documentation
```
docs(api): 📝 Update API authentication docs

Technical:
  • 🔧 Add code examples
User Impact:
  • 💡 Improve usage clarity

-JMB
```

## Validation Rules

1. First line:
   - Must start with valid commit type
   - May include optional scope in parentheses
   - Must include emoji
   - Total length ≤50 characters

2. Body:
   - 2-3 categorized bullet points
   - Each bullet ≤72 characters
   - Must use appropriate category emojis
   - Categories must be indented with 2 spaces

3. Signature:
   - Must end with "-JMB"

## Tips

1. Use completions:
   - Type commit type followed by colon
   - Select from suggested emojis
   - Accept with `<C-y>`

2. Quick Template:
   - Use `<leader>cm` in normal mode
   - Template auto-inserts in empty commit messages

3. Validation:
   - Run validation before saving
   - Fix any reported issues
   - Ensure proper emoji usage