# $Id: Makefile,v 1.3 2000-07-30 21:07:44 andy Exp $

SHELL=/bin/sh
EMACS=emacs

#SOURCES=$(shell -c ls -t *.el)
SOURCES=*.el
XZ=xz
ETAGS=etags

all: 

.xz.dat: $(SOURCES)
	$(XZ) -ywqn $(SOURCES)

TAGS: $(SOURCES)
	$(ETAGS) $(SOURCES)

compile:
	$(EMACS) --batch -l byte-compile-directory

.PHONY: compile
