(require 'xdb)

;
; local xdb query
;
(defun list-db ()
  (let* ((out (zap-buffer-1 "*stdout*"))
	 (err (zap-buffer-1 "*stderr*"))
	 (res (and out err (shell-command "mysql --batch --execute=\"show databases\"" out err))))
    (if
	(= res 0) 
	(progn
	  (set-buffer out)
	  (cdr (split (buffer-string) "
")
	       ))
      (error
       (progn
	 (set-buffer err)
	 (buffer-string)
	 )
       )
      )
    )
  )
; 

(defvar *local-txdb-options* nil)
; e.g. '("-h" "-" "-b" "fx" "-u" "a"))

(defun xlq (s)  (interactive "squery: ")
  "perform a query against a local instance of mysql"
  (let ((*txdb-options* *local-txdb-options*))
    (clean-string (x-query s)))
  )

; (xl "select count(*) from f")
; (xl "describe f")

;; run query on contents of current buffer (i.e. sql code)

(defun xlb () (interactive)
  (let ((*txdb-options* *local-txdb-options*)
	(b (zap-buffer *x*)))
    (insert (x-query (setq *x-query* query)))
    (switch-to-buffer-other-window b)
    (beginning-of-buffer)
    (x-query-mode)
    (run-hooks 'after-x-query-hook)
    (other-window-1)
    )
  )

(defun xlbi ()  (interactive)
  (let ((*txdb-options* *local-txdb-options*))
    (call-interactively 'txdbi)
    )
  )
