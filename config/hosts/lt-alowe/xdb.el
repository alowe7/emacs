(put 'post-xdb 'rcsid
 "$Id: xdb.el,v 1.3 2010-05-15 01:04:10 alowe Exp $")

; what does this do?
(put 'post-xdb 'host-init (this-load-file))

(chain-parent-file t)

; (add-hook 'xdb-init-hook 'xdb-login)
(require 'comint)

(defvar *prompt-for-null-txdb-connection-string* nil "read txdb connection from minibuffer when not defined")

; todo -- promote and prompt on first use
(when (and (not (member "-b" (txdb-options))) *prompt-for-null-txdb-connection-string*)
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
