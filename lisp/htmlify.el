(put 'htmlify 'rcsid "$Id: htmlify.el,v 1.4 2000-10-03 16:44:07 cvs Exp $")

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