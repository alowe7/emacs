# $Id: Makefile,v 1.19 2001-10-25 22:27:20 cvs Exp $

SHELL=/bin/sh
INSTALL = install
LOCALBIN = /usr/local/bin
.PHONY: FORCE

uname := $(shell uname)
hostname := $(shell hostname)

# XZFLAGS = -t1

SOURCES := $(shell find ./lisp ./site-lisp -type f -a ! -name "*~" -a ! -name "*,v" -a ! -path "*CVS*")
#CONFIGS := config/os/$(uname) config/hosts/$(hostname)
# config/version/$(shell emacs --batch --version)
#
CONFIGS := $(shell find ./config -type f -a ! -name "*~" -a ! -name "*,v" -a ! -path "*CVS*")
XZ=xz

SITE_LISP := $(shell find /usr/share/emacs/site-lisp -type f -name "*.el")

ETAGS=etags

all: .autoloads

.autoloads: $(SOURCES) $(CONFIGS) $(SITE_LISP)
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
