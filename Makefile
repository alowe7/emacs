# $Id$

SHELL=/bin/sh

INSTALL = install
LOCALBIN = /usr/local/bin
SHARE=/usr/share/emacs
SITESTART = $(SHARE)/site-lisp/site-start.d

EMACS := $(shell which emacs  2> /dev/null)
ifeq ($(strip $(EMACS)),)
EMACS := $(EMACSPATH)/emacs
endif

TOP=$(shell pwd)

.PHONY: FORCE

MAKE_AUTOLOADS  := $(shell which make-autoloads  2> /dev/null)
PKG=a
AUTOLOADS=$(PKG)-autoloads

XZ=xz
XZFLAGS = -t1

SOURCES := $(shell find ./lisp -type f -name "*.el")

# only search for relevant configs -- use perl hostname to ensure portability
CONFIGS := $(shell ./find-configs)
# search all configs
# CONFIGS := $(shell find ./config -type f -name "*.el")

ETAGS=etags

all: autoloads

ship: autoloads
	mkdir -p $(SITESTART)
	install -m 444 $(AUTOLOADS) $(SITESTART)

autoloads: FORCE 
	$(MAKE_AUTOLOADS) --top=$(TOP) --prefix=$(PKG)  $(CONFIGS) $(SOURCES)  > $(AUTOLOADS)
	@echo $(AUTOLOADS) rebuilt

.xz.dat: $(SOURCES) $(CONFIGS) ~/.emacs
	$(XZ) $(XZFLAGS) -n $^
	@echo .xz.dat rebuilt

.emacs.dat: 
	@$(XZ) $(XZFLAGS) -a -ywqn -f$@  < $(shell find $(EMACS_DIR)/lisp  -type f -name "*.el")
	@echo .emacs.dat rebuilt

TAGS: $(SOURCES) $(CONFIGS)
	$(ETAGS) $^

clean:
	rm -f .xz.dat TAGS $(AUTOLOADS) *.elc

compile:
	$(MAKE) --directory lisp compile


