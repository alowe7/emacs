(put 'http 'rcsid 
 "$Id: http.el,v 1.5 2002-09-17 17:55:53 cvs Exp $")
(provide 'http)

(defun http-get (url)
  (interactive (list (let* ((word (indicated-word ":/._")) (u (read-string (format "url (%s): " word)))) (if (string* u) u word))))
  (let ((s (perl-command "get" url))
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

