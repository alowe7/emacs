# $Id: Makefile,v 1.11 2001-04-27 11:37:32 cvs Exp $

SHELL=/bin/sh
uname := $(shell uname)
hostname := $(shell hostname)

SOURCES := $(shell find ./lisp ./site-lisp -type f -a ! -name "*~" -a ! -name "*,v" -a ! -path "*CVS*")
#CONFIGS := config/os/$(uname) config/hosts/$(hostname)
# config/version/$(shell emacs --batch --version)
#
CONFIGS := $(shell find ./config -type f -a ! -name "*~" -a ! -name "*,v" -a ! -path "*CVS*")
XZ=xz

SITE_LISP := $(shell find /usr/share/emacs/site-lisp -type f -name "*.el")

ETAGS=etags

all: .autoloads .xz.dat


.autoloads: $(SOURCES) $(CONFIGS)
	@./make-autoloads $(SOURCES) $(CONFIGS) > .autoloads
	@echo .autoloads rebuilt

.xz.dat: $(SOURCES) $(CONFIGS) $(SITE_LISP)
	@$(XZ) -ywqn $(SOURCES) $(CONFIGS) $(SITE_LISP)
	@echo .xz.dat rebuilt

TAGS: $(SOURCES) $(CONFIGS)
	$(ETAGS) $(SOURCES) $(CONFIGS)

clean:
	rm -f .xz.dat TAGS .autoloads
