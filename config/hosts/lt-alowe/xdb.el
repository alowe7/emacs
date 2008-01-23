(put 'post-xdb 'rcsid
 "$Id: xdb.el,v 1.1 2008-01-23 05:51:11 alowe Exp $")

; what does this do?
(put 'post-xdb 'host-init (this-load-file))

(chain-parent-file t)

; (add-hook 'xdb-init-hook 'xdb-login)
(require 'comint)

(unless (member "-b" (txdb-options))
  (let* ((default-user "a") 
	 (default-db "x")
	 (user (read-string (format "txdb user (%s): " default-user) nil nil default-user))
	 (sword (comint-read-noecho (format "sword for %s: " user) t))
	 (db  (read-string (format "db (%s): " default-db) nil nil default-db)))
    (add-txdb-option "-b"  (format "%s/%s@%s" user sword db))
    )
  )

(defvar *local-txdb-options* nil "list of options to provide txdb for local connections")

; override
(defun maybe-browse-url-at-point () 
  " `w3m-browse-url' to view indicated url
"
  (interactive)
  (save-excursion
    (let ((url (thing-at-point 'url)))
      (w3m-browse-url url)
      )
    )
  )
