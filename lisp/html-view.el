(put 'html-view 'rcsid "$Id: html-view.el,v 1.4 2000-10-03 16:44:07 cvs Exp $")
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

(or (assoc "html"  file-assoc-list)
		(push
		 '("html" . html-view)
		 file-assoc-list))

(or (assoc "htm"  file-assoc-list)
		(push
		 '("htm" . html-view)
		 file-assoc-list))

