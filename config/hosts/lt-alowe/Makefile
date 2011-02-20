# $Id: Makefile 517 2010-11-14 19:22:01Z alowe $

SHELL=/bin/sh
EMACS=$(EMACSPATH)/emacs

# only ship and autoload approved sources
SOURCES=host-init.el people.el
TARGETS := $(SOURCES:.el=.elc)

.PHONY: FORCE

all: compile

compile: $(SOURCES)
	$(EMACS) --batch  --load=byte-compile-directory.el -e batch-byte-compile $^

clean:
	@rm -f *.elc

