(put 'html-view 'rcsid 
 "$Id: html-view.el,v 1.8 2001-09-03 23:00:45 cvs Exp $")
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

