# $Id: Makefile,v 1.30 2003-12-15 22:46:30 cvs Exp $

SHELL=/bin/sh
INSTALL = install
LOCALBIN = /usr/local/bin
SITE_LISP=/usr/share/emacs/site-lisp
EMACS=$(EMACS_DIR)/bin/emacs

.PHONY: FORCE

XZ=xz
# XZFLAGS = -t1

SOURCES := $(shell find ./lisp -type f -name "*.el")

# only search for relevant configs -- use perl hostname to ensure portability
CONFIGS := $(shell ./find-configs)
# search all configs
# CONFIGS := $(shell find ./config -type f -name "*.el")

SITE_LISP := $(shell find $(SITE_LISP) -type f -name "*.el")

# search for autoloads among site lisps
SITE_LOADS := $(shell find $(SITE_LISP) -type f -name ".autoloads")

ETAGS=etags

all: .autoloads

.autoloads: FORCE $(SOURCES) $(CONFIGS) $(SITE_LOADS)
	@./make-autoloads $^ > .autoloads
	@echo .autoloads rebuilt

.xz.dat: $(SOURCES) $(CONFIGS) $(SITE_LISP) ~/.emacs
	$(XZ) $(XZFLAGS) -ywqn $^
	@echo .xz.dat rebuilt

.emacs.dat: 
	@$(XZ) $(XZFLAGS) -a -ywqn -f$@  < $(shell find $(EMACS_DIR)/lisp  -type f -name "*.el")
	@echo .emacs.dat rebuilt

TAGS: $(SOURCES) $(CONFIGS)
	$(ETAGS) $^

clean:
	rm -f .xz.dat TAGS .autoloads

ship: $(LOCALBIN)/make-autoloads

$(LOCALBIN)/make-autoloads: make-autoloads
	$(INSTALL) -m 555 $^ $(LOCALBIN)

compile:
	$(shell cd lisp; $(EMACS) --batch --load ~/emacs/lisp/byte-compile-directory.el)
