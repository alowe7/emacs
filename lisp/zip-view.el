(put 'zip-view 'rcsid 
 "$Id: zip-view.el,v 1.9 2002-01-10 18:47:23 cvs Exp $")
(provide 'zip-view)

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


(defun zip-extract (f) (interactive)
  (let* ((b (zap-buffer (format "%s *zip*" f))))

    (call-process "pkzip" nil b nil "-extract" 
		  (replace-in-string " " "\\ " 
				     (w32-canonify 
				      (file-name-sans-extension f)
				      )
				     )
		  )
    (save-excursion
      (set-buffer b)
      (not-modified)
      (beginning-of-buffer)
      )
    )
  )

(defun dired-zip-view () (interactive)
	(zip-view (dired-get-filename)) 
	)

(defun dired-zip-extract () (interactive)
	(zip-extract (dired-get-filename)) 
	)

