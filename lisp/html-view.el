(put 'html-view 'rcsid 
 "$Id: html-view.el,v 1.6 2001-08-20 02:09:14 cvs Exp $")
(provide 'html-view)

(defun dired-html-view () (interactive)
  (html-view (dired-get-filename)))

(defun html-view (&optional fn) 
  "view specified file or buffer as html"
  (interactive)
  (let* ((fn (or fn (buffer-file-name)))
	 (b (zap-buffer (format "%s *html* " (file-name-sans-extension fn))))
	 (s (eval-process "perl" (find-script "fast-html-format") fn)))
    (pop-to-buffer b)
    (insert s)
    (beginning-of-buffer)
    (not-modified)
    (view-mode)
    )
  )

(add-file-association "html"  file-assoc-list)

(add-file-association "htm"  file-assoc-list)
