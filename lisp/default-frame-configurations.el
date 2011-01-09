(put 'default-frame-configurations 'rcsid
 "$Id$")

; see set-frame-configuration
(defun default-frame-configuration (font)
  (let ((c (assoc font default-frame-configurations)))
    (if c
	(progn
	  (modify-frame-parameters nil (cdr c))
	  (setq default-fontspec (frame-parameter nil 'font))
	  (set-frame-font   default-fontspec)
	  )
      (message "no entry for %s found in default-frame-configurations" font )
      )
    )
  )

(provide 'default-frame-configurations)
