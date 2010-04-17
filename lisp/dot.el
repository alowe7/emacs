(put 'dot 'rcsid
 "$Id: dot.el,v 1.1 2010-04-17 18:51:05 alowe Exp $")

;; obsolete?

(defvar *config-load-path*
  (mapcar 'expand-file-name (list (format "~/config/hosts/%s" (system-name) )
				  (format "~/config/os/%s" (symbol-name window-system)) "~"))
  )

(defun dotfn (fn)
  (loop for a in *config-load-path*
	do (let ((afn (format "%s/%s" a fn)))
	  (if (file-exists-p afn) (scan-file afn))
	  )))
