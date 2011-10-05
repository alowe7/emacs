(put 'post-psgml 'rcsid
 "$Id: post-psgml.el 1017 2011-06-06 04:32:11Z alowe $")

(add-hook 'sgml-mode-hook 'debug)

; (setq sgml-public-map  '((regexp . filename)))
; (setq sgml-catalog-files '("catalog" "/usr/local/lib/sgml/catalog"))

(defvar *sgml-display-log* nil "if set pop up log buffer on psgml warnings and errors")

(defun sgml-display-log ()
  (let ((buf (get-buffer sgml-log-buffer-name)))
    (when buf
      (when *sgml-display-log*
	(display-buffer buf))
      (setq sgml-log-last-size 
	    (with-current-buffer buf
	      (point-max))))
    )
  )
