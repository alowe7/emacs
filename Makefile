# $Id: Makefile,v 1.4 2000-10-30 19:11:42 cvs Exp $

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

all: auto-autoloads .xz.dat


auto-autoloads: $(SOURCES)
	@./make-autoloads $(SOURCES) > auto-autoloads
	@echo auto-autoloads rebuilt

.xz.dat: $(SOURCES) $(CONFIGS)
	@$(XZ) -ywqn $(SOURCES) $(CONFIGS)

TAGS: $(SOURCES) $(CONFIGS)
	$(ETAGS) $(SOURCES) $(CONFIGS)

clean:
	rm -f xz.dat TAGS auto-autoloads
