# $Id: Makefile,v 1.5 2000-11-20 02:36:16 cvs Exp $

SHELL=/bin/sh
uname := $(shell uname)
hostname := $(shell hostname)

SOURCES := $(shell find ./lisp ./site-lisp -name "*.el")
#CONFIGS := config/os/$(uname) config/hosts/$(hostname)
# config/version/$(shell emacs --batch --version)
#
CONFIGS := $(shell find ./config  -type f -a ! -name "*~" -a ! -name "*,v")
XZ=xz
ETAGS=etags

all: .autoloads .xz.dat


.autoloads: $(SOURCES)
	@./make-autoloads $(SOURCES) > .autoloads
	@echo .autoloads rebuilt

.xz.dat: $(SOURCES) $(CONFIGS)
	@$(XZ) -ywqn $(SOURCES) $(CONFIGS)

TAGS: $(SOURCES) $(CONFIGS)
	$(ETAGS) $(SOURCES) $(CONFIGS)

clean:
	rm -f .xz.dat TAGS .autoloads
