# $Id: Makefile,v 1.24 2003-04-07 21:52:54 cvs Exp $

SHELL=/bin/sh
INSTALL = install
LOCALBIN = /usr/local/bin
.PHONY: FORCE

XZ=xz
# XZFLAGS = -t1

SOURCES := $(shell find ./lisp -type f -name "*.el")

# only search for relevant configs
# CONFIGS := $(shell find ./config -type f -name "*.el" -a \( -path "*`uname`*" -o -path "*`hostname`*" \))
# search all configs
CONFIGS := $(shell find ./config -type f -name "*.el")

SITE_LISP := $(shell find /usr/share/emacs/site-lisp -type f -name "*.el")

# search for autoloads among site lisps
SITE_LOADS := $(shell find /usr/share/emacs/site-lisp -type f -name ".autoloads")

ETAGS=etags

all: .autoloads

.autoloads: FORCE $(SOURCES) $(CONFIGS) $(SITE_LOADS)
	@./make-autoloads $^ > .autoloads
	@echo .autoloads rebuilt

.xz.dat: $(SOURCES) $(CONFIGS) $(SITE_LISP) ~/.emacs
	$(XZ) $(XZFLAGS) -ywqn $^
	@echo .xz.dat rebuilt

.emacs.dat: 
	@$(XZ) $(XZFLAGS) -a -ywqn -f$@  < $(shell find /usr/local/lib/emacs-20.7/lisp  -type f -name "*.el")
	@echo .emacs.dat rebuilt

TAGS: $(SOURCES) $(CONFIGS)
	$(ETAGS) $^

clean:
	rm -f .xz.dat TAGS .autoloads

ship: $(LOCALBIN)/make-autoloads

$(LOCALBIN)/make-autoloads: make-autoloads
	$(INSTALL) -m 555 $^ $(LOCALBIN)

compile:
	(cd lisp; emacs --batch --load ~/emacs/lisp/byte-compile-directory.el)
