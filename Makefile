# $Id: Makefile,v 1.10 2001-03-26 16:33:10 cvs Exp $

SHELL=/bin/sh
uname := $(shell uname)
hostname := $(shell hostname)

SITE := $(shell find /usr/local/lib/emacs-20.7/site-lisp -type f -a ! -name "*~" -a ! -name "*,v" -a ! -path "*CVS*")
SOURCES := $(shell find ./lisp ./site-lisp -type f -a ! -name "*~" -a ! -name "*,v" -a ! -path "*CVS*")
#CONFIGS := config/os/$(uname) config/hosts/$(hostname)
# config/version/$(shell emacs --batch --version)
#
CONFIGS := $(shell find ./config -type f -a ! -name "*~" -a ! -name "*,v" -a ! -path "*CVS*")
XZ=xz
ETAGS=etags

all: .autoloads .xz.dat


.autoloads: $(SOURCES) $(CONFIGS) $(SITE)
	@./make-autoloads $(SOURCES) $(CONFIGS) > .autoloads
	@echo .autoloads rebuilt

.xz.dat: $(SOURCES) $(CONFIGS)
	@$(XZ) -ywqn $(SOURCES) $(CONFIGS)
	@echo .xz.dat rebuilt

TAGS: $(SOURCES) $(CONFIGS)
	$(ETAGS) $(SOURCES) $(CONFIGS)

clean:
	rm -f .xz.dat TAGS .autoloads
