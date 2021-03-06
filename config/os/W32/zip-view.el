(put 'zip-view 'rcsid 
 "$Id$")

(cond 
 ((executable-find "pkzip")
  (setq *unzip-command* "pkzip"
	*unzip-view-options* "-view"
	*zip-command* "pkzip"
	*zip-extract-options* "-extract" 
	*zip-add-options* "-add")
  )
 (t
  (when (executable-find "zip")
    (setq *zip-command* "zip"
	  *zip-add-options* nil))
  (when (executable-find "unzip")
    (setq *unzip-command* "unzip"
	  *zip-extract-options* nil
	  *unzip-view-options* "-l")
    )
  )
 )

(defun zip-view (f) (interactive)

  (unless (boundp '*unzip-command*)
    (error "*unzip-command* not bound.  please install a zipper"))
  (let* ((f (if (string-match " " f) (gsn f) f))
	 (b (zap-buffer (format "%s *zip*" f))))

    (debug)

    (call-process *unzip-command* nil b nil *unzip-view-options* 
		  (replace-regexp-in-string
		   " " "\\ " 
		   (w32-canonify 
		    (file-name-sans-extension f)
		    )	
		   )
		  )
    (pop-to-buffer b)
    (set-buffer-modified-p nil)
    (goto-char (point-min))
    )
  )

(add-file-association "zip" 'zip-view)


(defun zip-extract (f) (interactive)

  (unless (boundp '*unzip-command*)
    (error "*unzip-command* not bound.  please install a zipper"))

  (let* ((b (zap-buffer (format "%s *zip*" f))))

    (call-process *unzip-command* nil b nil  *zip-extract-options*
		  (replace-in-string " " "\\ " 
				     (w32-canonify 
				      (file-name-sans-extension f)
				      )
				     )
		  )
    (with-current-buffer b
      (set-buffer-modified-p nil)
      (goto-char (point-min))
      )
    )
  )


(defun zip-add (zipfile &rest files) (interactive)
  (unless (boundp '*zip-command*)
    (error "*zip-command* not bound.  please install a zipper"))

  (let* ((b (zap-buffer (format "%s *zip*" zipfile))))

    (debug)
    (apply 'call-process (nconc (list *zip-command* nil b nil *zip-add-options*
				      (replace-in-string " " "\\ " 
							 (w32-canonify 
							  (file-name-sans-extension zipfile)
							  )
							 )) files)
	   )
    (with-current-buffer b
      (set-buffer-modified-p nil)
      (goto-char (point-min))
      )
    )
  )


(defun dired-zip-view () (interactive)
	(zip-view (dired-get-filename)) 
	)

(defun dired-zip-extract () (interactive)
	(zip-extract (dired-get-filename)) 
	)

(defun dired-zip-add (fn) (interactive "szip file: ")
  (apply 'zip-add (nconc (list fn) (dired-get-marked-files t)))
  )

(provide 'zip-view)
