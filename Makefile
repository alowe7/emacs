# $Id$

SHELL=/bin/sh

INSTALL = install
LOCALBIN = /usr/local/bin
SHARE=/usr/share/emacs
SITESTART = $(SHARE)/site-lisp/site-start.d

TOP=$(shell pwd)

.PHONY: FORCE

MAKE_AUTOLOADS  := $(shell which make-autoloads  2> /dev/null)
PKG=a
AUTOLOADS=$(PKG)-autoloads

XZ=xz
XZFLAGS = -t1 -r

SOURCES := $(shell find ./lisp -type f -name "*.el")

# only search for relevant configs -- use perl hostname to ensure portability
CONFIGS := $(shell ./find-configs)
# search all configs
# CONFIGS := $(shell find ./config -type f -name "*.el")

ETAGS=etags

all: compile autoloads

ship: compile autoloads
	mkdir -p $(SITESTART)
	install -m 444 $(AUTOLOADS) $(SITESTART)

autoloads: FORCE 
	$(MAKE_AUTOLOADS) --compiled --top=$(TOP) --prefix=$(PKG)  $(CONFIGS) $(SOURCES)  > $(AUTOLOADS)
	@echo $(AUTOLOADS) rebuilt

.xz.dat: FORCE
	$(XZ) $(XZFLAGS) -n $(SOURCES) $(CONFIGS) ~/.emacs
	@echo .xz.dat rebuilt

TAGS: $(SOURCES) $(CONFIGS)
	$(ETAGS) $^

clean:
	rm -f .xz.dat TAGS $(AUTOLOADS) *.elc

compile:
	$(MAKE) --directory lisp compile
	$(MAKE) --directory config compile


