(put 'msvc 'rcsid
 "$Id: msvc.el,v 1.3 2004-03-27 19:05:17 cvs Exp $")

(defun msvc-clean () (interactive)
  (fix-dos-file)
  (let ((p (point)))
    (goto-char (point-max))
   (condition-case foo
       (while (> (point) (point-min))
	 (backward-list 1)
	 (c-indent-exp t)
	 )
     (error nil))
    (goto-char p)
    )
  )

(defun toggle-tabs  (arg)
  (interactive "P")
  (set-tabs (cond ((and (listp arg) (not (null arg))) (car arg)) ((integerp arg) arg) ((eq tab-width 8) 2) (t 8)))
  (message "tab-width: %d" tab-width))

(global-set-key (vector '\C-tab) 'toggle-tabs)
