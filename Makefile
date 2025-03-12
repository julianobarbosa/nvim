# Core variables
PLUGIN_ROOT = lua/custom/plugins
TEST_DIR = $(PLUGIN_ROOT)/tests
NVIM = nvim
NVIM_TEST = NVIM_TEST=1 $(NVIM)
PLENARY = $(PLUGIN_ROOT)/pack/vendor/start/plenary.nvim

# Main test targets
.PHONY: test test-unit test-integration test-file coverage setup clean deps

# Run all tests
test: deps
	$(NVIM_TEST) --headless -c "PlenaryBustedDirectory $(TEST_DIR)/specs/ {minimal_init = '$(TEST_DIR)/minimal_init.lua'}"

# Run unit tests only
test-unit: deps
	$(NVIM_TEST) --headless -c "PlenaryBustedDirectory $(TEST_DIR)/specs/unit/ {minimal_init = '$(TEST_DIR)/minimal_init.lua'}"

# Run integration tests only
test-integration: deps
	$(NVIM_TEST) --headless -c "PlenaryBustedDirectory $(TEST_DIR)/specs/integration/ {minimal_init = '$(TEST_DIR)/minimal_init.lua'}"

# Run specific test file
test-file: deps
	@[ "$(FILE)" ] && $(NVIM_TEST) --headless -c "PlenaryBustedFile $(FILE)"

# Coverage targets
coverage: deps
	$(NVIM_TEST) --headless \
		-c "lua require('luacov').start()" \
		-c "PlenaryBustedDirectory $(TEST_DIR)/specs/" \
		-c "lua require('luacov').stop()" \
		-c "lua require('luacov-console')('default')" \
		-c "q"

coverage-html: coverage
	luacov-html
	@echo "Coverage report generated in coverage/report.html"

coverage-badge: coverage
	@luacov-badge -u

# CI targets
ci: ci-setup ci-test coverage-badge

ci-setup: deps
	@echo "Setting up CI environment..."

ci-test:
	@echo "Running CI test suite..."
	$(MAKE) test

# Setup targets
setup: deps
	@echo "Setting up test environment..."
	mkdir -p $(TEST_DIR)/{specs,helpers}

clean:
	rm -rf coverage
	rm -f luacov.*
	rm -f .luacov.stats.out

deps:
	@[ -d "$(PLENARY)" ] || git clone https://github.com/nvim-lua/plenary.nvim.git $(PLENARY)
