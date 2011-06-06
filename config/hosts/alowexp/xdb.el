(put 'post-xdb 'rcsid
 "$Id$")

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

(setq *local-txdb-options* '("-h" "-" "-b" "upm" "-u" "a"))

; extend the default implementation
(defadvice  txdb-options (around 
			  hook-txdb-options
			  first 
			  activate)

  (let ((*txdb-options* *txdb-options*)
	(extra-args (ad-get-args 0)))
    (unless (member "-h" extra-args)
      (if (evilnat)
	  (add-txdb-option "-h" "enoch:3306")
	(add-txdb-option "-h" "localhost:13306")))
    ad-do-it
    *txdb-options*)
  )
; (if (ad-is-advised 'txdb-options) (ad-unadvise 'txdb-options))
