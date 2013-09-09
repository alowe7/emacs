# $Id: Makefile 1043 2012-02-22 16:25:27Z alowe $

SHELL=/bin/sh

ifneq ($(strip $(EMACSPATH)),)
EMACS := $(EMACSPATH)/emacs
else
EMACS := $(shell which emacs  2> /dev/null)
endif

SOURCES=host-init.el compile.el domain-stuff.el dscm-blog-helper.el gpg.el gpg-helpers.el gud.el keys.el lsinstall.el opt-init.el post-comint.el post-grep.el post-locate.el post-people.el post-perl-mode.el post-psgml.el post-w3m.el pre-w3m.el py-loads.el rtf-mode.el session-init-file.el tw-init.el unicode.el vbs.el w3m-helpers.el w3m-loads.el whack-post-init.el wx.el
TARGETS := $(SOURCES:.el=.elc)

.PHONY: FORCE

all: compile

compile: $(SOURCES)
	$(EMACS) --batch  --load=byte-compile-directory.el -e batch-byte-compile $^

clean:
	@rm -f *.elc

