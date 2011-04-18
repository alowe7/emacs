(put 'pre-xdb 'rcsid
 "$Id$")


(defun xh* (thing)
  " select where what or how like THING in x.howto"
  (interactive "show to where what or how like: ")
	(let* ((*txdb-options* *txdb-options*)
	       (words (split thing))
	       (query
		(concat "("
			(mapconcat 'identity
				   (list
				    (mapconcat 'identity
					       (loop for x in words collect (format "what like '%%%s%%'" x))
					       " and ")

				    (mapconcat 'identity
					       (loop for x in words collect (format "how like '%%%s%%'" x))
					       " and ")
				    )
				   ") or (")
			")"))
	       )

		(add-txdb-option "-v" "2")
		(x-query-1 (format  "select * from howto where %s" query))
		)
  )

; put on xdb-init-hook first time through
(require 'comint)

(defvar *xdbuser* (getenv "XDBUSER"))
(defvar *xdbdb* (getenv "XDB"))
(defvar *xdbsword* nil)
(defvar *xdbhost* (getenv "XDBHOST"))

(defun xdb-login (arg)
  "ask for a sword, unless we already have one
  with prefix arg, ask anyway
"
  (interactive "P")
  ; (message "(%s,%s)" *xdbuser* (make-string (length *xdbsword*) ?*))

  (setq *xdbdb* (string* (read-string (format "{user{/sword}@}db (%s): "  *xdbdb*)) *xdbdb*))

  (if (string-match "@" *xdbdb*)
      (progn
	(remove-txdb-option "-u")
	(setq *xdbuser* nil)
	(if (string-match "/" *xdbdb*)
	    (progn
	      (remove-txdb-option "-s")
	      (setq *xdbsword* nil)
	      )
	  (setq *xdbsword* (string* (comint-read-noecho (format "sword for user %s (%s): " *xdbuser* (make-string (length *xdbsword*) ?*))) (unless arg *xdbsword*))))
	)
    (setq *xdbuser* (string* (read-string (format "user (%s): "  *xdbuser*)) *xdbuser*))
    )

  (setq *xdbhost* (string* (read-string (format "host{:port} (%s): "  *xdbhost*)) *xdbhost*))
  (and *xdbuser* (add-txdb-option "-u" *xdbuser*))
  (and *xdbsword* (add-txdb-option "-s" *xdbsword*))
  (add-txdb-option "-b" *xdbdb*)
  (add-txdb-option "-h" *xdbhost*)

  )
; (call-interactively 'xdb-login)
