(put 'data 'rcsid 
 "$Id: data.el,v 1.2 2001-02-19 21:57:20 cvs Exp $")
(provide 'data)

;; this module initializes host specific data variables

(setq doc-directory data-directory)

(defvar *people-database* nil "list of contact files")

