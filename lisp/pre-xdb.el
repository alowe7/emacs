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

(defun remove-txdb-option (option)
  (setq *txdb-options* (remove2* option *txdb-options*))
  )

(defun add-txdb-option (option value)
  (cond ((not (string* value)) 
  ; no value means remove it
	 (remove-txdb-option option))
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

(defvar *xdbuser* (getenv "XDBUSER"))
(defvar *xdbsword* nil)

(defun xdb-login (&optional arg)
  "ask for a sword, unless we already have one
  with prefix arg, ask anyway
"
  (interactive "P")
; (message "(%s,%s)" *xdbuser* (make-string (length *xdbsword*) ?*))

  (if (or arg (not (or *xdbsword* *xdbuser*)))
    (progn
      (setq *xdbuser* (string* (read-string (format "user (%s): "  *xdbuser*)) *xdbuser*))
      (setq *xdbsword* (string* (comint-read-noecho (format "sword for user %s (%s): " *xdbuser* (make-string (length *xdbsword*) ?*))) (unless arg *xdbsword*)))
      (add-txdb-option "-u" *xdbuser*)
      (add-txdb-option "-s" *xdbsword*)
      )
    (unless arg (message "using db user <%s>" *xdbuser*))
    )
  )
