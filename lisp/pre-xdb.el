;; this is so wrong

(defun remove2* (item seq)
  "like remove* but removes item and follower"
  (let* ((pred1 '(lambda (x) (if (string= x item) (progn (setq pred pred2) nil) t)))
	 (pred2 '(lambda (x) (progn (setq pred pred1) nil)))
	 (pred pred1)) 
    (loop for x in seq when (funcall pred x) collect x )))

; (remove2* "-s" *txdb-options*)


; (setq *txdb-options*  nil)

;; todo: (unless (member "-s" *txdb-options* ) ...
;; todo: this should be an assoc of some kind to override duplicates

(defun add-txdb-option (option value)
  (cond ((not (string* value)) 
	 ; no value means remove it
	 (setq *txdb-options* (remove2* "-s" *txdb-options*)))
	((not (member option *txdb-options*))
  ; not already there
	 (setq *txdb-options* 
	       (nconc
		(list option value)
		*txdb-options* 
		)
	       ))
	(t
  ; already there.  replace value
	 (rplaca (cdr (member option *txdb-options*)) value)
	 )
	)
  )


; put on xdb-init-hook first time through

(defun xdb-login (&optional arg)
  (interactive "P")

  ; ask for a sword
  ; with arg, present current login info
  (if arg (message "(%s,%s)" *xdbuser* (make-string (length *xdbsword*) ?*))
    (progn
      (setq *xdbuser* (string* (read-string (format "user (%s): " (getenv "XDBUSER"))) (getenv "XDBUSER")))
      (setq *xdbsword* (comint-read-noecho (format "sword for user %s: " *xdbuser*)))
      (add-txdb-option "-u" *xdbuser*)
      (add-txdb-option "-s" *xdbsword*)
      )
    )
  )
