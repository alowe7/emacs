# $Id$

SHELL=/bin/sh

ifneq ($(strip $(EMACSPATH)),)
EMACS := $(EMACSPATH)/emacs
else
EMACS := $(shell which emacs  2> /dev/null)
endif

SOURCES=host-init.el compile.el domain-stuff.el dscm-blog-helper.el gpg.el gpg-helpers.el keys.el lsinstall.el opt-init.el post-comint.el post-grep.el post-locate.el  post-perl-mode.el post-psgml.el rtf-mode.el session-init-file.el tw-init.el unicode.el vbs.el whack-post-init.el wx.el
# py-loads.el post-people.el

TARGETS := $(SOURCES:.el=.elc)

.PHONY: FORCE

all: compile

compile: $(SOURCES)
	$(EMACS) --batch  --load=byte-compile-directory.el -e batch-byte-compile $^

clean:
	@rm -f *.elc

