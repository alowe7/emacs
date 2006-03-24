; this should oughta be in dscm.el
(defvar *dscm-root* (expand-file-name "/documents/dscm"))
(defvar *peek-xml-pat*  "^[ 	
]*<" )
(defvar *peek-php-pat* "^[ 	
]*<\\?php")
(defvar *peek-perl-pat* "^#!(perl|/usr/local/bin/perl)")

(defun auto-auto-mode ()
  "when a member of  `find-file-hooks' this function provides an alternative way to derive an auto mode.
for example, by directory, or maybe peeking."

  ; but only if major-mode hasn't already been selected
  (if (eq major-mode 'fundamental-mode)
      (cond
       ((string-match  *peek-php-pat* (buffer-string))
	(php-mode))
       ((string-match *peek-xml-pat* (buffer-string))
  ; if the first non-whitespace char is langle, guess sgml.  this includes jsp
	(sgml-mode))
       ((string-match  *peek-perl-pat* (buffer-string))
	(perl-mode))
       )
    )
  )
(provide 'auto)