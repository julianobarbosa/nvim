Configure NeoVim as a modern IDE with the following specifications:

1. Core Setup Requirements:
- Install and configure essential plugins using a package manager (e.g., Packer, Lazy)
- Set up LSP for code intelligence and autocompletion
- Configure treesitter for syntax highlighting
- Implement fuzzy finding capabilities
- Enable Git integration

2. Key Features to Implement:
- Code completion with snippets
- Integrated terminal
- File explorer
- Status line
- Tab/Buffer management
- Error diagnostics
- Quick formatting
- Find/Replace across files

3. Performance Guidelines:
- Lazy load plugins when possible
- Use lua-based plugins over vimscript
- Keep startup time under 100ms
- Implement efficient keybindings
- Cache plugin data appropriately

4. Required Output Format:
- Provide complete lua configuration files
- Include detailed comments for each major section
- List all required system dependencies
- Document custom keybindings
- Explain any special setup steps

Communication Guidelines for Project Work

When working on tasks and projects, please follow these communication protocols:

Task Updates:
- Provide a concise, plain-language summary after completing each task
- Classify changes as: Minor (quick fixes), Moderate (several hours), or Significant (major impact)
- For significant changes: Submit a brief implementation plan and wait for approval before proceeding
- Include both completed items and remaining work in all progress reports

Clarification & Prioritization:
- If requirements are unclear, ask specific questions to resolve ambiguity
- Verify the priority level of new requests (High/Medium/Low)
- Adjust communication frequency and detail based on task priority
- Escalate blockers or dependencies immediately

Format for Updates:
- Subject: [Project Name] - [Task Name] - [Status]
- Summary: 1-2 sentences in non-technical terms
- Change Impact: Minor/Moderate/Significant
- Completed: [Bullet points]
- Pending: [Bullet points]
- Questions/Blockers: [If any]

I.  Core Features (MVP - Minimum Viable Product)

Language Support (Intelligent Autocompletion, Linting, Formatting, Debugging):

Python:

LSP: pyright (preferred for performance and type checking), python-lsp-server (fallback)
Linters: flake8, mypy, pylint (configurable)
Formatters: black, ruff, autopep8, yapf (configurable)
Debugger: debugpy (integrated with DAP - Debug Adapter Protocol)
REPL: Integrated Python REPL (e.g., using iron.nvim)
Rust:

LSP: rust-analyzer
Linters: clippy
Formatters: rustfmt
Debugger: codelldb or gdb (via DAP)
Cargo Integration: Run cargo build, cargo test, cargo run directly from Neovim.
Go:

LSP: gopls
Linters: golangci-lint
Formatters: gofmt, goimports
Debugger: delve (via DAP)
Go Tooling Integration: Run go build, go test, go run, etc.
Lua:

LSP: lua_ls (sumneko's Lua Language Server)
Linters: luacheck
Formatters: stylua
Debugger: nvim-dap + luadbg or compatible DAP adapter.
PHP:

LSP: intelephense (preferred), phpactor (fallback)
Linters: phpcs, psalm, phpstan
Formatters: php-cs-fixer
Debugger: xdebug (via DAP)
Terraform:

LSP: terraform-ls
Linters: tflint
Formatters: terraform fmt
Validation: terraform validate
Plan/Apply Integration: Easy execution of terraform plan and terraform apply.
YAML:

LSP: yaml-language-server
Linters: yamllint
Formatters: prettier (with YAML plugin)
Ansible:

LSP: ansible-language-server
Linters: ansible-lint
Playbook Execution: Run playbooks directly within Neovim.
Syntax Highlighting & Completion: For Ansible roles, tasks, etc.
PowerShell:

LSP: powershell-editor-services
Linters: PSScriptAnalyzer
Formatters: powershell-formatter in the PowerShell extension.
Debugger: Integrated PowerShell debugger (via DAP).
REPL: Integrated PowerShell console.
Project Management:

Project Detection: Automatically detect project root based on common markers (e.g., Cargo.toml, go.mod, pyproject.toml, .git, etc.). Use a plugin like project.nvim or similar.
Fuzzy Finder Integration: telescope.nvim (highly recommended) or fzf-lua. Enable quick file opening, buffer switching, symbol searching, and grep within the project.
File Tree Navigation: nvim-tree.lua (modern, fast) or neo-tree.nvim. Should support Git integration (show file status).
Version Control (Git):

gitsigns.nvim: Display Git changes in the sign column (additions, deletions, modifications).
fugitive.vim or vim-fugitive: Seamless Git integration for staging, committing, pushing, pulling, branching, merging, blaming, etc.
diffview.nvim: A sophisticated diff viewer to visualize changes and conflicts.
User Interface:

Status Line: lualine.nvim (highly configurable, written in Lua) or a similar status line plugin. Display active LSP status, Git branch, file encoding, line/column, etc.
Tab Line: bufferline.nvim or similar. Display open buffers as tabs.
Syntax Highlighting: treesitter (for improved, context-aware highlighting). Ensure parsers are installed for all supported languages.
Completion: nvim-cmp (modern completion framework). Configure sources for LSP, snippets, paths, buffers, etc.
Snippets: luasnip (Lua-based snippet engine). Provide pre-defined snippets for all supported languages and allow user-defined snippets.
Debugging:

nvim-dap: The core Debug Adapter Protocol implementation.
nvim-dap-ui: A user-friendly interface for interacting with the debugger (breakpoints, stepping, variable inspection, call stack).
Language-Specific DAP Configurations: Pre-configured setups for each supported language's debugger (see Language Support section).
Terminal Integration:

toggleterm.nvim: Easily manage and toggle integrated terminal windows within Neovim. Allows running build commands, tests, REPLs, etc., without leaving the editor.
Workspace Management

Using workspaces.nvim or similar allow to save and load workspaces.
Save and load sessions, and automatically restore the last session on startup.
II.  Advanced Features (Post-MVP)

Refactoring Tools:

LSP-based refactoring (rename, extract method, etc.) where available.
Language-specific refactoring tools integrated as needed.
Remote Development:

Integration with ssh and potentially containers (Docker) for remote editing and debugging.
Test Runner Integration:

Plugins to run tests for each language (e.g., vim-test or similar) and display results in a quickfix window or dedicated UI.
Code Navigation:

Go to definition, find references, go to implementation, etc., using LSP.
telescope.nvim integration for project-wide symbol searching.
AI-Powered Code Completion (Optional):

Integration with tools like GitHub Copilot or Tabnine (requires careful consideration of licensing and privacy).
Collaborative Editing (Stretch Goal):

Explore options for real-time collaborative editing (complex, but potentially valuable).
III.  Technical Design

Plugin Manager: lazy.nvim (modern, performant, written in Lua). This will handle the installation, updating, and configuration of all plugins.
Configuration: Primarily Lua-based (init.lua). This allows for greater flexibility, performance, and access to Neovim's Lua API. Consider providing a well-documented default configuration with options for easy customization.
Modularity: Design the IDE as a collection of independent, well-defined Neovim plugins. This promotes maintainability, extensibility, and allows users to pick and choose the features they need.
Performance:
Prioritize asynchronous operations (using Neovim's built-in job control and libuv).
Lazy-load plugins whenever possible.
Use efficient data structures and algorithms.
Profile regularly to identify and address performance bottlenecks.
Documentation: Comprehensive documentation is crucial. This includes:
Installation instructions.
Configuration options.
Usage guides for each feature.
Troubleshooting tips.
Contribution guidelines.
Testing: Implement unit and integration tests (using a framework like plenary.nvim) to ensure stability and prevent regressions.
IV.  Implementation Steps

Setup Core Neovim Environment: Install Neovim (>= 0.8 recommended), lazy.nvim, and basic plugins like nvim-treesitter, lualine.nvim, bufferline.nvim, telescope.nvim, nvim-cmp, luasnip, gitsigns.nvim, fugitive.vim, diffview.nvim, nvim-tree.lua, toggleterm.nvim, project.nvim.
Language Server Setup: Install the necessary language servers for each supported language (see Language Support section). Configure mason.nvim to facilitate the installation process and nvim-lspconfig for managing LSP client configurations.
LSP Configuration: Configure nvim-lspconfig to connect to each language server, enable features like autocompletion, diagnostics, formatting, and code actions.
Completion and Snippets: Configure nvim-cmp with sources for LSP, snippets (using luasnip), and other desired sources.
Debugging Setup: Install nvim-dap, nvim-dap-ui, and the necessary DAP adapters for each language. Create DAP configurations for launching and debugging projects.
Implement Core Features: Work through the "Core Features" list, adding and configuring plugins as needed.
Testing and Refinement: Thoroughly test each feature, fix bugs, and optimize performance.
Documentation: Write clear and comprehensive documentation.
Release MVP: Make the initial version available to users.
Iterate: Gather user feedback, prioritize features, and continue development (moving to the "Advanced Features" list).
V.  Key Considerations

User Experience: Strive for a consistent and intuitive user experience across all languages and features.
Maintainability: Keep the codebase clean, well-documented, and modular.
Extensibility: Design the IDE to be easily extended with new features and languages.
Community: Foster a welcoming and helpful community around the project.
This specification provides a solid foundation for building a powerful and versatile Neovim-based IDE. The modular design, leveraging Neovim's plugin ecosystem, allows for a highly customizable and performant development environment. Remember to prioritize user feedback and iterate on the design as the project evolves.

# Workflow Preferences 

## Task Execution
- Only implement features directly requested to avoid scope creep.
- Split complex tasks into smaller, manageable steps.
- Pause after each significant step for your approval to proceed.

## Planning and Progress
- Before starting a major feature, outline a plan in plan.md for your review.
- Log completed work in progress.md after each task.
- Update TODO.txt with upcoming tasks after each step.
- If context exceeds 100k tokens, summarize it in context-summary.md and begin a new chat.

## Testing and Feedback
- Write basic tests for core functionality like text extraction and Markdown conversion.
- Propose edge case tests, like very long threads or deleted comments.
- Adapt level of detail in steps based on your feedback.