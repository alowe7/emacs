#all: xz.dat TAGS
# $Id: Makefile,v 1.2 2000-07-17 21:01:39 a Exp $

SHELL=/bin/sh
FIND=/bin/find
uname := $(shell uname)
hostname := $(shell hostname)

SOURCES := $(shell /bin/find ./lisp ./site-lisp -name "*.el")
#CONFIGS := config/os/$(uname) config/hosts/$(hostname)
# config/version/$(shell emacs --batch --version)
#
CONFIGS := $(shell /bin/find ./config  -type f -a ! -name "*~" -a ! -name "*,v")
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
