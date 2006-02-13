(put 'post-xdb 'rcsid
 "$Id: xdb.el,v 1.3 2006-02-13 16:35:22 alowe Exp $")

(put 'post-xdb 'host-init (this-load-file))

(chain-parent-file t)

(require 'ctl-slash)
(define-key ctl-/-map "x" 'txdbi)
(define-key ctl-/-map "q" 'xq)
(define-key ctl-/-map "t" 'xt)
(define-key ctl-/-map "l" 'xl)
(define-key ctl-/-map "n" 'xn)
(define-key ctl-/-map "w" 'xql)

(define-key ctl-/-map "\C-l" 'xlq) ; not to be confused with xql ...?-)

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

