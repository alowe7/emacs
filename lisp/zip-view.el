(provide 'zip-view)

;(pop file-assoc-list)

(defun dired-zip-view () (interactive)
	(zip-view (dired-get-filename)) 
	)

(defun zip-view (f) (interactive)
  (let* ((b (zap-buffer (format "%s *zip*" f))))

    (call-process "pkzip" nil b nil "-view" (format "\"%s\"" 
						    f))
    (pop-to-buffer b)
    (not-modified)
    (beginning-of-buffer)
    )
  )

(or (assoc "zip"  file-assoc-list)
		(push
		 '("zip" . zip-view)
		 file-assoc-list))






