(put 'auto 'rcsid "$Id$")

(chain-parent-file t)

  ; if the first non-whitespace char is langle, guess sgml.  this includes jsp
(defvar *peek-xml-pat*  "^[ 	
]*<" )
(defvar *peek-perl-pat* "^#!(perl|/usr/local/bin/perl|/perl)")
(defvar *peek-php-pat* "^[ 	
]*<\\?php")

(loop for x in `(
		 (,*peek-php-pat* . php-mode)
		 (,*peek-xml-pat* sgml-mode)
		 (,*peek-perl-pat* perl-mode)
		 )
      do
      (add-to-list '*auto-mode-alist* x)
      )
; *auto-mode-alist*

