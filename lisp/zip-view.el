(put 'zip-view 'rcsid 
 "$Id: zip-view.el,v 1.8 2001-08-20 04:24:43 cvs Exp $")
(provide 'zip-view)

(defun dired-zip-view () (interactive)
	(zip-view (dired-get-filename)) 
	)

(defun zip-view (f) (interactive)
  (let* ((b (zap-buffer (format "%s *zip*" f))))

    (call-process "pkzip" nil b nil "-view" 
		  (replace-in-string " " "\\ " 
				     (w32-canonify 
				      (file-name-sans-extension f)
				      )
				     )
		  )
    (pop-to-buffer b)
    (not-modified)
    (beginning-of-buffer)
    )
  )

(add-file-association "zip" 'zip-view)
