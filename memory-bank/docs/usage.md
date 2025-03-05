# Python Debugging System Usage Guide

## Quick Start

### Installation
1. Ensure dependencies:
   ```bash
   :PackerSync  # Install required plugins
   :checkhealth dap  # Verify setup
   ```

2. Framework Detection:
   ```lua
   -- Automatically detects Django/FastAPI projects
   -- Uses appropriate configuration
   ```

### Basic Usage

1. Start Debugging:
   ```
   :lua require('dap').continue()  -- F5
   ```

2. Debug Controls:
   - Step Over: F10
   - Step Into: F11
   - Step Out: Shift+F11
   - Toggle Breakpoint: F9

### Framework-Specific Features

1. Django Projects:
   ```lua
   -- Auto-configures Django settings
   -- Handles runserver debugging
   -- Manages environment variables
   ```

2. FastAPI Applications:
   ```lua
   -- Supports hot reload
   -- Configures PYTHONPATH
   -- Handles import time profiling
   ```

### Performance Monitoring

1. Basic Metrics:
   ```lua
   -- Import time tracking
   -- Memory usage monitoring
   -- Stack trace analysis
   ```

2. Profile Current File:
   ```lua
   -- Select "Python: Profile Current File"
   -- View metrics in DAP UI
   ```

## Troubleshooting

1. Common Issues:
   - Plugin specification errors: Run `:PackerSync`
   - Framework detection: Check project structure
   - Performance monitoring: Verify Python debugpy

2. Debug Log:
   ```lua
   :lua require('dap').set_log_level('DEBUG')