(defconst rcs-id "$Id: htmlify.el,v 1.3 2000-07-30 21:07:46 andy Exp $")

(defun htmlify (&optional fn)
	(interactive "finput file: ")
	(let ((b (get-buffer-create "*HTML view*")))
		(shell-command (concat "dsgml " fn) b)
		(pop-to-buffer b)
		))

(defun visit-html-file () (interactive)
  (htmlify (buffer-file-name)))

(setq html-mode-hook
'(lambda nil (define-key html-mode-map "" 'visit-html-file)))