(provide 'data)
(require 'apache)

(defvar *people-database* nil "list of contact files")

(setq *people-database*
      (catlist (read-file (fwf "db/contacts$")) ?
	       )
      )
