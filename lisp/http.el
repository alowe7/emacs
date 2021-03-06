(put 'http 'rcsid 
 "$Id$")
(provide 'http)

(defun http-get (url &optional credentials)
  (interactive (list (let* ((word (indicated-word ":/._"))
			    (u (read-string (format "url (%s): " word)))) 
		       (if (string* u) u word))
		     (and current-prefix-arg (read-string "credentials: "))
		     ))

  (let ((s (apply 'perl-command (nconc (list "get" url) (and credentials (list "-C" credentials)))))
	(b (zap-buffer (format "*get %s*" url))))
    (insert s)
    (goto-char (point-min))
    (set-buffer-modified-p nil)
    (toggle-read-only t)
    (view-mode)
    (pop-to-buffer b)
    )
  )

