# $Id: Makefile,v 1.2 2000-07-30 20:43:20 cvs Exp $

SHELL=/bin/sh
EMACS=/usr/local/lib/emacs-19.34/bin/emax

#SOURCES=$(shell -c ls -t *.el)
SOURCES=*.el
XZ=xz
ETAGS=etags

all: 

xz.dat: $(SOURCES)
	$(XZ) -ywqn $(SOURCES)

TAGS: $(SOURCES)
	$(ETAGS) $(SOURCES)

compile:
	$(EMACS) --batch -l byte-compile-directory > compile.log 2>&1

.PHONY: compile
