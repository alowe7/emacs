(defconst rcs-id "$Id: data.el,v 1.3 2000-07-30 21:07:45 andy Exp $")
(provide 'data)
(require 'apache)

(defvar *people-database* nil "list of contact files")

(setq *people-database*
      (catlist (read-file (fwf "db/contacts$")) ?
	       )
      )
