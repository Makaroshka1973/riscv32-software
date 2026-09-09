.PHONY: all sys apps clean

all: sys apps

sys:
	$(MAKE) -C sys

APP_DIRS := $(wildcard apps/*)

apps: sys
	@for dir in $(APP_DIRS); do \
		if [ -f $$dir/Makefile ]; then \
			echo "Building $$dir..."; \
			$(MAKE) -C $$dir; \
		fi \
	done

clean:
	@for dir in $(APP_DIRS); do \
		if [ -f $$dir/Makefile ]; then \
			echo "Cleaning $$dir..."; \
			$(MAKE) -C $$dir clean; \
		fi \
	done
	$(MAKE) -C sys clean
