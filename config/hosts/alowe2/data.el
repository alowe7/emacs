(put 'data 'rcsid 
 "$Id: data.el,v 1.1 2001-03-06 12:46:10 cvs Exp $")
(provide 'data)
(require 'http)

;; this module initializes host specific data variables

(setq doc-directory data-directory)

(defvar *people-database* nil "list of contact files")


