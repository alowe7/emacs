# $Id$

SHELL=/bin/sh

INSTALL = install
LOCALBIN = /usr/local/bin
SHARE=/usr/share/emacs/site-lisp

EMACS := $(shell which emacs  2> /dev/null)
ifeq ($(strip $(EMACS)),)
EMACS := $(EMACSPATH)/emacs
endif

TOP := $(shell pwd)

.PHONY: FORCE

XZ=xz
XZFLAGS = -t1

SOURCES := $(shell find ./lisp -type f -name "*.el")

# only search for relevant configs -- use perl hostname to ensure portability
CONFIGS := $(shell ./find-configs)
# search all configs
# CONFIGS := $(shell find ./config -type f -name "*.el")

SITE_LISP := $(shell find $(SHARE) -type f -name "*.el")

ETAGS=etags

all: .autoloads

.autoloads: FORCE 
	echo $(CONFIGS) $(SOURCES)  $(SITE_LISP) | xargs ./make-autoloads --top $(TOP) > .autoloads
	@echo .autoloads rebuilt

#  $(SITE_LISP)
.xz.dat: $(SOURCES) $(CONFIGS) ~/.emacs
	$(XZ) $(XZFLAGS) -n $^
	@echo .xz.dat rebuilt

.emacs.dat: 
	@$(XZ) $(XZFLAGS) -a -ywqn -f$@  < $(shell find $(EMACS_DIR)/lisp  -type f -name "*.el")
	@echo .emacs.dat rebuilt

TAGS: $(SOURCES) $(CONFIGS)
	$(ETAGS) $^

clean:
	rm -f .xz.dat TAGS .autoloads

ship: FORCE
	$(INSTALL) -m 555 make-autoloads $(LOCALBIN)

compile:
	$(shell cd lisp; $(EMACS) --batch --load ~/emacs/lisp/byte-compile-directory.el)

