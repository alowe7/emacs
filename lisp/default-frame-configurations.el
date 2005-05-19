(put 'default-frame-configurations 'rcsid
 "$Id: default-frame-configurations.el,v 1.1 2005-05-19 20:52:25 cvs Exp $")

; see set-frame-configuration
(defun default-frame-configuration (font)
  (let ((c (assoc font default-frame-configurations)))
    (if c
	(progn
	  (modify-frame-parameters nil (cdr c))
	  (setq default-fontspec (frame-parameter nil 'font))
	  (set-default-font  default-fontspec) ; maybe redundant?
	  )
      (message "no entry for %s found in default-frame-configurations" font )
      )
    )
  )

(provide 'default-frame-configurations)
