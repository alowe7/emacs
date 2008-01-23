(put 'http 'rcsid 
 "$Id: http.el,v 1.6 2008-01-23 05:51:11 alowe Exp $")
(provide 'http)

(defun http-get (url &optional credentials)
  (interactive (list (let* ((word (indicated-word ":/._"))
			    (u (read-string (format "url (%s): " word)))) 
		       (if (string* u) u word))
		     (and current-prefix-arg (read-string "credentials: "))
		     ))

  (let ((s (apply 'perl-command (nconc (list "get" url) (and credentials (list "-C" credentials)))))
	(b (zap-buffer (format "*get %s*" url))))
    (insert-string s)
    (beginning-of-buffer)
    (set-buffer-modified-p nil)
    (toggle-read-only t)
    (view-mode)
    (pop-to-buffer b)
    )
  )

(fset 'wget 'http-get)

(if (boundp 'x-query-mode-map)
    (define-key x-query-mode-map "g" 'wget)
  )

