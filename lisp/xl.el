(require 'xdb)

;
; local xdb query
;
(defvar *local-txdb-options* '("-h" "-" "-b" "fx" "-u" "a"))

(defun xlq (s)  (interactive "squery: ")
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

(global-set-key "" 'xlb)