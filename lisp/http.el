(put 'http 'rcsid 
 "$Id: http.el,v 1.4 2002-03-02 22:39:40 cvs Exp $")
(provide 'http)

(defun http-get (url)
  (interactive (list (let* ((word (indicated-word ":/._")) (u (read-string (format "url (%s): " word)))) (if (string* u) u word))))
  (perl-command "get" url)
  (pop-to-buffer "*perl*")
  )

(fset 'wget 'http-get)

(if (boundp 'x-query-mode-map)
    (define-key x-query-mode-map "g" 'wget)
  )

