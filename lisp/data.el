(put 'data 'rcsid "$Id: data.el,v 1.4 2000-10-03 16:44:06 cvs Exp $")
(provide 'data)
(require 'apache)

(defvar *people-database* nil "list of contact files")

(setq *people-database*
      (catlist (read-file (fwf "db/contacts$")) ?
	       )
      )
