SRC := $(shell find . -name "*.org") $(shell find images/ css/ js/ -type f 2>/dev/null)
BUILD_SCRIPT := build-site.el
BUILD_CMD := emacs -Q --script ${BUILD_SCRIPT}

.PHONY: build
build: ${SRC} ${BUILD_SCRIPT}
	$(BUILD_CMD)

.PHONY: run
run: build
	cd public && python2 -m SimpleHTTPServer
