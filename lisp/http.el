(put 'http 'rcsid 
 "$Id: http.el,v 1.2 2001-11-15 17:36:59 cvs Exp $")
(provide 'http)

(defun http-get (url)
  (interactive (list (let* ((word (indicated-word ":/._")) (u (read-string (format "tag (%s): " word)))) (if (string* u) u word))))
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

