(put 'html-view 'rcsid 
 "$Id: html-view.el,v 1.10 2002-03-13 17:57:56 cvs Exp $")
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


(defun html-browse (fn) (interactive "sfn: ")
  (let ((p (format "*html-browse %s*" fn)))
    (start-process p (zap-buffer p) "cmd"
		   "/c" (file-association fn)
		   (if (string-match "^http://" fn) fn (w32-canonify fn))
		   )
    )
  )
