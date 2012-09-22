(put 'whack-post-init 'rcsid
 "$Id: whack-post-init.el 1069 2012-08-15 17:34:18Z alowe $")

; post load hooks don't work on autoloads
(eval-when-compile
  (let* ((default-directory "/src/emacs/config/common")
	 (l (directory-files "." nil "post-.*\\.el$")))
    (dolist (x l)
	    (unless (file-directory-p x)
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
  )
(provide 'whack-post-init)
