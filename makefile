# makefile
.PHONY: help formatted apps
.DEFAULT_GOAL := help

apps:
	./mackup_to_rsync.sh ./mackup/mackup/applications ./apps

submodules:
	git submodule update --recursive --remote

help:
	@echo "help"
	@echo "    shows this message"
	@echo ""
	@echo "apps"
	@echo "    Use Mackup to make a new apps dir with rsync files. "
	@echo ""
	@echo "submodules"
	@echo "    Update git submodules. "
