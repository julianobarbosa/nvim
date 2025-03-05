# Technical Context

## Debugging Infrastructure

### DAP Components
1. Core Debugger (nvim-dap)
   - Base debugging functionality
   - Event handling
   - Configuration management

2. Debug UI (nvim-dap-ui)
   - Split window layout
   - Performance monitoring panels
   - REPL integration

3. Python Support (nvim-dap-python)
   - Framework-specific configs
   - Python debugger integration
   - Environment handling

### Framework Support
1. Django
   - Runserver debugging
   - Settings module integration
   - Environment configuration

2. FastAPI
   - Hot reload support
   - PYTHONPATH configuration
   - Performance monitoring

### Performance Features
1. Monitoring
   - Import time tracking
   - Library code debugging
   - Resource usage stats

2. UI Integration
   - Auto-opening on events
   - Performance metrics display
   - Stack trace visualization

## Development Setup
- Neovim with Lua support
- Python with debugpy
- Framework development tools