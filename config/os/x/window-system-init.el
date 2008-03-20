(put 'window-system-init 'rcsid
 "$Id: window-system-init.el,v 1.3 2008-03-20 03:29:15 slate Exp $")

(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

(defun load-p (fn)
  (and (file-exists-p fn) (load-file fn) t)
  )

(when (load-p "/z/el/ssh-helpers.el")
  (setq *remote-host* (ssh-client-host))
  (let ((dir (expand-file-name (concat *configdir* "hosts/"  *remote-host*))))
    (and (file-directory-p dir)
	 (add-to-load-path dir t)
	 )
    )
  )

; look for any remote-host specific config files
(when (string* *remote-host*)
  (let ((remote-config-directory 
	 (expand-file-name
	  (format "os/%s/remote-hosts/%s" 
		  (symbol-name window-system) *remote-host*)
	  *configdir*)
	 ))
    (when (file-directory-p remote-config-directory)
      (add-to-load-path remote-config-directory)
      (load (expand-file-name "remote-host-init" remote-config-directory ) t t)
      )
    )
  )

