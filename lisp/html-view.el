(put 'html-view 'rcsid 
 "$Id: html-view.el,v 1.13 2004-04-04 16:24:27 cvs Exp $")
(provide 'html-view)

(defun dired-html-view () 
  "run `html-view' on indicated file in `dired-mode'"
  (interactive)
  (html-view (dired-get-filename)))

(defun html-view (&optional fn) 
  "view specified file or buffer as html"
  (interactive)
  (let* ((fn (or fn (buffer-file-name)))
	 (b (zap-buffer (format "%s *html* " (file-name-sans-extension fn))))
	 (s (perl-command "fast-html-format" fn)))
    (pop-to-buffer b)
    (insert s)
    (beginning-of-buffer)
    (not-modified)
    (view-mode)
    )
  )


(defun html-browse (fn) (interactive "sfn: ")
  (start-process (format "*html-browse %s*" fn) "cmd"
		 "/c" (file-association fn)
		 (if (string-match "^http://" fn) fn (w32-canonify fn))
		 )
  )
