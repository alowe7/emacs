(put 'http 'rcsid 
 "$Id: http.el,v 1.3 2001-11-21 19:37:54 cvs Exp $")
(provide 'http)

(defun http-get (url)
  (interactive (list (let* ((word (indicated-word ":/._")) (u (read-string (format "url (%s): " word)))) (if (string* u) u word))))
  ; (debug)
  (perl-command "get" url)
  (let ((fn (expand-file-name (format "%s/%s.htm" (getenv "TMP") (gensym)))))
    (set-buffer " *perl*")
    (write-region (point-min) (point-max) fn)
    (html-view fn)
    )
  )

(fset 'wget 'http-get)

(if (boundp 'x-query-mode-map)
    (define-key x-query-mode-map "g" 'wget)
  )

