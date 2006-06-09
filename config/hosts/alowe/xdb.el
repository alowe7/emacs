(put 'post-xdb 'rcsid
 "$Id: xdb.el,v 1.4 2006-06-09 19:19:04 alowe Exp $")

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

