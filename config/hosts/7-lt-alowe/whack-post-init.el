
; post load hooks don't work on autoloads
(eval-when-compile
  (let* ((default-directory "/src/emacs/config/common")
	 (l (get-directory-files nil nil "post-.*\\.el$")))
    (loop for x in l do 
	  (apply 'eval-after-load
		 (let ((basename (file-name-sans-extension x)))
		   (list
		    (intern (substring basename (progn (string-match "post-" x) (match-end 0))))
		    `(load ,basename nil t))
		   )
		 )
	  )
    )
  )
(provide 'whack-post-init)
