SRC := $(shell find . -name "*.org") $(shell find images/ css/ js/ -type f 2>/dev/null)
EMACS := emacs -batch -Q
TANGLE_FLAGS := --eval "(require 'org)" --eval '(setq org-src-preserve-indentation t)'

.PHONY: build
build: ${SRC} build-site.el
	emacs -Q --script build-site.el

.PHONY: run
run: build
	cd public && python2 -m SimpleHTTPServer

build-site.el .github/workflows/publish.yml: notes/automating-website-deployment.org
	$(EMACS) $(TANGLE_FLAGS) --eval '(org-babel-tangle-file "$<")'
