(put 'data 'rcsid 
 "$Id: data.el,v 1.1 2000-12-05 15:38:10 cvs Exp $")
(provide 'data)
(require 'http)

;; this module initializes host specific data variables

(setq doc-directory data-directory)

(defvar *people-database* nil "list of contact files")


