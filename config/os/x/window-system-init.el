(put 'window-system-init 'rcsid
 "$Id: window-system-init.el,v 1.2 2008-01-26 20:13:48 slate Exp $")

(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

(when (file-directory-p "/z/el")
  (add-to-load-path "/z/el")
  (require 'ssh-helpers)
  (setq *remote-host* (ssh-client-host))

  (add-to-load-path
   (expand-file-name (concat *configdir* "hosts/"  *remote-host*)) t)

  ; tbd pull in host-init for *remote-host* ?

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

