# $Id: Makefile,v 1.8 2001-01-22 19:47:07 cvs Exp $

SHELL=/bin/sh
uname := $(shell uname)
hostname := $(shell hostname)

SOURCES := $(shell find ./lisp ./site-lisp -type f -a ! -name "*~" -a ! -name "*,v" -a ! -path "*CVS*")
#CONFIGS := config/os/$(uname) config/hosts/$(hostname)
# config/version/$(shell emacs --batch --version)
#
CONFIGS := $(shell find ./config -type f -a ! -name "*~" -a ! -name "*,v" -a ! -path "*CVS*")
XZ=xz
ETAGS=etags

all: .autoloads .xz.dat


.autoloads: $(SOURCES) $(CONFIGS)
	@./make-autoloads $(SOURCES) $(CONFIGS) > .autoloads
	@echo .autoloads rebuilt

.xz.dat: $(SOURCES) $(CONFIGS)
	@$(XZ) -ywqn $(SOURCES) $(CONFIGS)
	@echo .xz.dat rebuilt

TAGS: $(SOURCES) $(CONFIGS)
	$(ETAGS) $(SOURCES) $(CONFIGS)

clean:
	rm -f .xz.dat TAGS .autoloads
