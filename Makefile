# $Id: Makefile,v 1.15 2001-07-07 08:53:34 cvs Exp $

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

.autoloads: $(SOURCES) $(CONFIGS)
	@./make-autoloads $(SOURCES) $(CONFIGS) $(SITE_LISP) > .autoloads
	@echo .autoloads rebuilt

.xz.dat: $(SOURCES) $(CONFIGS) $(SITE_LISP)
	@$(XZ) $(XZFLAGS) -ywqn $(SOURCES) $(CONFIGS) $(SITE_LISP)
	@echo .xz.dat rebuilt

TAGS: $(SOURCES) $(CONFIGS)
	$(ETAGS) $(SOURCES) $(CONFIGS)

clean:
	rm -f .xz.dat TAGS .autoloads

ship: $(LOCALBIN)/make-autoloads

$(LOCALBIN)/make-autoloads: make-autoloads
	$(INSTALL) -m 555 $^ $(LOCALBIN)
