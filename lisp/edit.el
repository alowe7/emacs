(put 'edit 'rcsid 
 "$Id: edit.el,v 1.13 2004-10-15 22:09:44 cvs Exp $")

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

(defvar *tab-width-ring* (vector 2 4 8))
(defvar *tab-width-ring-index* 1)

(defun set-tabs (arg)
  "roll tab-width through `*thin-tab-width*' and `*fat-tab-width*'
with optional prefix ARG set to ARG"
  (interactive "P")
  (setq tab-width
	(cond ((and (listp arg) (not (null arg))) (car arg))
	      ((integerp arg) arg)
	      (t (aref *tab-width-ring* 
		       (setq *tab-width-ring-index* (% (1+ *tab-width-ring-index*) (length *tab-width-ring*)))))
	      ))
  (message "tab-width: %d" tab-width)
  (recenter)
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


(defun reverse-lines (arg)
  "like it says.
interactive with ARG says reverse whole buffer"
  (interactive "P")
  (if arg
      (reverse-lines-region (point-min) (point-max))
    (reverse-lines-region (min (point) (mark)) (max (point) (mark)))
    )
  )

(defun reverse-lines-region (beg end)
  "like it says."
  (interactive "r")
  (let ((this-line (count-lines beg (point)))
	(num-lines (count-lines beg end)))
    (reverse-region beg end)
;    (goto-line (1+ (- num-lines this-line)))
    (goto-char end)
    (previous-line this-line)
    )
  )

(defun reverse-lines-1 ()
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
  "revisit file, forcing a refresh from disk"
  (interactive)

  (let ((fn (buffer-file-name))
	(p (point)))
    (if (or (not (buffer-modified-p)) 
	    (y-or-n-p (format "buffer %s is modified. discard changes? " (buffer-name))))
	(progn
	  (push-mark p t)
	  (revert-buffer nil t t)
	  (goto-char (min p (point-max)))
	  )
      )
    )
  )

(defun insert-eval-environment-variable (v)
  "insert value of specified environment VARIABLE"
  (interactive "sName of variable:")
  (insert (getenv v)))
