(put 'edit 'rcsid 
 "$Id: edit.el,v 1.4 2000-11-20 01:03:02 cvs Exp $")

;; edit and format functions

(defun line-as-region ()
" return indicated line as a region"
	(let ((x (point)) y z)
	  (beginning-of-line)
	  (setq y (point))
	  (end-of-line)
	  (setq z (point))
	  (goto-char x)
	  (list y z)))


(defun set-tabs (n)
  "set variable tab-width to N"
  (interactive "ntab width: ")
  (set-variable (quote tab-width) n)
  )

(defun kill-pattern (pat &optional n)
  "delete all ocurrences of PAT in current buffer.
if optional arg N is specified deletes additional N subsequent chars also"
  (beginning-of-buffer)
  (while 
      (re-search-forward pat nil t) 
    (delete-region (match-beginning 0) (+ (match-end 0) (or n 0)))
    )
  )

(defun wrap () 
  "toggle line truncation."
  (interactive)
  (if truncate-lines (set-variable 'truncate-lines nil) 
    (set-variable 'truncate-lines t))
  )

(defun wrap! () 
  (interactive)
  (set-variable 'truncate-lines t)
  )

(defun scroll-down-1 ()
  (interactive)
  (scroll-down 1)
  (if (not (bobp)) (previous-line 1))
  )

(defun scroll-up-1 ()
  (interactive)
  (scroll-up 1)
  (if (not (eobp)) (next-line 1))
  )


(defun toggle-case-fold ()
  "shortcut to toggle case-fold-search (q.v.)"
  (interactive)
  (setq case-fold-search (not case-fold-search))
  (message "case-fold-search is %s" (if case-fold-search "on" "off"))
  )


(defun space-to (col &optional char)
  (interactive "ncolumn: ")
  (let ((ncols (- col (current-column))))
    (while (> ncols 0) (progn (insert (or char " ")) (setq ncols (1- ncols))))
    )
  )



(defun reverse-lines ()
  (interactive)
  (beginning-of-buffer)
  (let (x)
    (while (not (eobp))
      (push (bgets) x)
      (kill-line 1)
      )
    (while x
      (insert (pop x))
      (insert "\n"))
    ))

(defun display-control-chars () 
  "toggle display of control chars"
  (interactive)
  (if (or (null ctl-arrow) (eq ctl-arrow t))
      (setq ctl-arrow 1)
    (setq ctl-arrow t)
    )
  )


(defun squeeze (begin end)
  (interactive "r")

  (let ((s
	 (trim-blank-lines
	  (trim-trailing-white-space
	   (trim-leading-white-space
	    (trim-blank-lines
	     (buffer-substring begin end)))))))

    (kill-region begin end)
    (insert s)
    (call-process-region begin (+ begin (length s))  "tr" t t nil "-s" "\" 	\"")
    ))


(defun find-file-force-refresh ()
  (interactive)
  (let ((fn (buffer-file-name)))
    (kill-buffer (current-buffer))
    (find-file fn)
    ))

(defun insert-eval-environment-variable (v)
  "insert value of specified environment VARIABLE"
  (interactive "sName of variable:")
  (insert (getenv v)))
