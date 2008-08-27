(put 'auto 'rcsid
 "$Id: auto.el,v 1.3 2008-08-27 00:48:59 alowe Exp $")

(defvar *peek-xml-pat*  "^[ 	
]*<" )
(defvar *peek-php-pat* "^[ 	
]*<\\?php")
(defvar *peek-perl-pat* "^#!(perl|/usr/local/bin/perl)")

(defun looking-at* (regexp)
  (save-excursion (goto-char (point-min)) (looking-at regexp))
  )

(defun auto-auto-mode ()
  "when a member of  `find-file-hooks' this function provides an alternative way to derive an auto mode.
for example, by directory, or maybe peeking."

  ; but only if major-mode hasn't already been selected
  (if (eq major-mode 'fundamental-mode)
      (cond
       ((looking-at*  *peek-php-pat*)
	(php-mode))
       ((looking-at* *peek-xml-pat*)
  ; if the first non-whitespace char is langle, guess sgml.  this includes jsp
	(sgml-mode))
       ((looking-at*  *peek-perl-pat*)
	(perl-mode))
       )
    )
  )
(provide 'auto)