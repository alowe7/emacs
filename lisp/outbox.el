(put 'outbox 'rcsid "$Id: outbox.el,v 1.4 2000-10-03 16:44:07 cvs Exp $")
(defvar ob-mode-map nil "")

(defun outbox-mode ()
	(use-local-map 
	 (or ob-mode-map 
			 (prog1
				 (setq  ob-mode-map  (copy-keymap view-mode-map))
				 (define-key ob-mode-map "n" 'ob-forward-message)
				 (define-key ob-mode-map "p" 'ob-backward-message)
				 (define-key ob-mode-map "g" 'ob-goto-message)
				 (define-key ob-mode-map "q" '(lambda () (interactive) (kill-buffer nil)))
				 )
			 )
	 )
	)

(defun ob-goto-message (n) 
	(interactive "nGoto Message: ") 
	(widen)
	(let ((p1 (progn
							(beginning-of-buffer)
							(forward-page n)
							(beginning-of-line)
							(point)
							))
				(p0 (progn
							(backward-page 1)
							(beginning-of-line)
							(point))))
		(narrow-to-region p0 p1)
		))

(defun ob-forward-message () 
	(interactive)
	(widen)
	(narrow-to-region 										
	 (progn (forward-page 1)
					(beginning-of-line)
					(point)
					)
	 (progn (forward-page 1)
					(beginning-of-line)
					(point)
					)
	 )
	(goto-char (point-min))
	)

(defun ob-backward-message () 
	(interactive)
	(widen)
	(narrow-to-region 										
	 (progn (forward-page -1)
					(beginning-of-line)
					(point)
					)
	 (progn (forward-page -1)
					(beginning-of-line)
					(point)
					)
	 )
	)

(defun vo () (interactive)
	; todo parameterize with outbox files
	(make-variable-buffer-local 'page-delimiter)

	(find-file mail-archive-file-name)
	(setq page-delimiter "


From ")
	(outbox-mode)
	)

