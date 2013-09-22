# $Id$

INSTALL = install
LOCALBIN = /usr/local/bin
SHARE=/usr/share/emacs
SITESTART = $(SHARE)/site-lisp/site-start.d
# COMPILE_AUTOLOADS = --compiled

EMACS := $(shell which emacs  2> /dev/null)

.PHONY: FORCE

PKG=a
AUTOLOADS=$(PKG)-autoloads
TOP=$(subst c:,,$(PWD))

XZ=xz
XZFLAGS = -t1 -r

SOURCES := $(shell find ./lisp -type f -name "*.el")

# only search for relevant configs -- use perl hostname to ensure portability
CONFIGS := $(shell ./find-configs ./config)

# search all configs
# CONFIGS := $(shell find ./config -type f -name "*.el")

ETAGS=etags

all: ship

# you want to make ship to get a-autoloads into sitestart
ship: autoloads
	mkdir -p $(SITESTART)
	install -m 444 $(AUTOLOADS) $(SITESTART)

autoloads: FORCE 
	$(EMACS) -batch --directory "/usr/share/emacs/site-lisp" --load="make-autoloads" --eval "(make-autoloads \"$(TOP)\" nil \"$(PKG)\")"

.xz.dat: FORCE
	$(XZ) $(XZFLAGS) -n $(SOURCES) $(CONFIGS) ~/.emacs
	@echo .xz.dat rebuilt

TAGS: $(SOURCES) $(CONFIGS)
	$(ETAGS) $^

clean:
	rm -f .xz.dat TAGS $(AUTOLOADS)
	$(MAKE) --directory lisp clean
	$(MAKE) --directory config clean

compile:
	$(MAKE) --directory lisp compile
	$(MAKE) --directory config compile


