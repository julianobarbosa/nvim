# GitHub Copilot Setup and Usage Guide

## Installation and Authentication

1. **Initial Setup**
   ```bash
   # Restart Neovim after plugin installation
   :Lazy sync    # Install/update plugins
   :Copilot auth # Start authentication process
   ```

2. **Authentication Process**
   - Run `:Copilot auth`
   - Follow the URL provided in your browser
   - Sign in to GitHub and authorize Copilot
   - Return to Neovim - you should see a success message

## Available Features

1. **Automatic Suggestions**
   - Appears automatically as you type
   - Shows gray "ghost text" for suggestions
   - Suggestions work in all file types
   - Smart context awareness

2. **Completion Integration**
   - Integrated with nvim-cmp
   - Shows Copilot suggestions in completion menu
   - Priority set after LSP but before snippets

3. **Statusline Integration**
   - Shows 🤖 when Copilot is active
   - Updates in real-time with Copilot status

## Keybindings

### Leader Key Commands (`<leader>c`)
- `t` - Toggle Copilot on/off
- `s` - Trigger suggestion manually
- `n` - Next suggestion
- `p` - Previous suggestion
- `a` - Accept current suggestion
- `d` - Dismiss current suggestion
- `r` - Refresh suggestions

### Insert Mode Keys
- `<C-j>` - Accept suggestion
- `<C-h>` - Dismiss suggestion
- `<C-n>` - Next suggestion
- `<C-p>` - Previous suggestion
- `<C-s>` - Trigger suggestion

### Commands
- `:Copilot toggle` - Enable/disable Copilot
- `:Copilot status` - Check current status
- `:Copilot panel` - Open suggestions panel

## Troubleshooting

1. **No Suggestions Appearing**
   - Verify authentication: `:Copilot status`
   - Check if enabled: `:Copilot toggle`
   - Ensure file type is not ignored
   - Try manual trigger: `<C-s>`

2. **Authentication Issues**
   - Re-run `:Copilot auth`
   - Check GitHub account status
   - Verify internet connection
   - Clear credentials and retry

3. **Performance Issues**
   - Disable in large files
   - Adjust updatetime if needed
   - Consider using manual triggers

## Best Practices

1. **Efficient Usage**
   - Review suggestions before accepting
   - Use `<C-n>`/`<C-p>` to cycle through options
   - Combine with LSP for best results
   - Learn to recognize suggestion patterns

2. **Code Quality**
   - Always review generated code
   - Test functionality after acceptance
   - Maintain consistent style
   - Document generated sections

3. **Performance Tips**
   - Use manual trigger in large files
   - Keep suggestions focused
   - Toggle off when not needed
   - Use with version control

4. **Integration with Workflow**
   - Combine with LSP completions
   - Use with snippets effectively
   - Leverage with documentation
   - Balance with manual coding

## Configuration Options

See `lua/custom/plugins/copilot.lua` for detailed configuration options including:
- Suggestion behavior
- Completion integration
- Keybinding customization
- Display preferences