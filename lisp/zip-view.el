(put 'zip-view 'rcsid 
 "$Id: zip-view.el,v 1.6 2001-02-09 14:29:51 cvs Exp $")
(provide 'zip-view)

;(pop file-assoc-list)

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

(or (assoc "zip"  file-assoc-list)
		(push
		 '("zip" . zip-view)
		 file-assoc-list))






