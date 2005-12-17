# $Id: Makefile,v 1.41 2005-12-17 05:01:09 tombstone Exp $

SHELL=/bin/sh

INSTALL = install
LOCALBIN = /usr/local/bin
SHARE=/usr/share/emacs/site-lisp
EXTRA=/x /z

EMACS := $(shell which emacs  2> /dev/null)
ifeq ($(strip $(EMACS)),)
EMACS := $(EMACSPATH)/emacs
endif

TOP := $(shell pwd)

.PHONY: FORCE

XZ=xz
XZFLAGS = -t1

SOURCES := $(shell find ./lisp -type f -name "*.el")

# only search for relevant configs -- use perl hostname to ensure portability
CONFIGS := $(shell ./find-configs)
# search all configs
# CONFIGS := $(shell find ./config -type f -name "*.el")

SITE_LISP := $(shell find $(SHARE) -type f -name "*.el")
EXTRA_LISP := $(shell find $(EXTRA) -type f -name "*.el")

# search for autoloads among site lisps
SITE_LOADS := $(shell find $(EXTRA) -type f -name ".autoloads")

ETAGS=etags

all: .autoloads

.autoloads: FORCE 
	./make-autoloads --top $(TOP)  $(CONFIGS) $(SOURCES)  > .autoloads
	[ -z "$(SITE_LOADS)" ] || cat $(SITE_LOADS) >> .autoloads
	@echo .autoloads rebuilt

.xz.dat: $(SOURCES) $(CONFIGS) $(SITE_LISP) $(EXTRA_LISP) ~/.emacs
	$(XZ) $(XZFLAGS) -n $^
	@echo .xz.dat rebuilt

.emacs.dat: 
	@$(XZ) $(XZFLAGS) -a -ywqn -f$@  < $(shell find $(EMACS_DIR)/lisp  -type f -name "*.el")
	@echo .emacs.dat rebuilt

TAGS: $(SOURCES) $(CONFIGS)
	$(ETAGS) $^

clean:
	rm -f .xz.dat TAGS .autoloads

ship: FORCE
	$(INSTALL) -m 555 make-autoloads $(LOCALBIN)

compile:
	$(shell cd lisp; $(EMACS) --batch --load ~/emacs/lisp/byte-compile-directory.el)
