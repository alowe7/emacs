(put 'eval-utils 'rcsid
 "$Id: eval-utils.el,v 1.6 2010-09-24 01:19:40 alowe Exp $")
(provide 'eval-utils)

(require 'zap)

;; file and directory handling utilities

(defun read-file (f &optional chomp)
  "returns contents of FILE as a string
with optional second arg CHOMP, applies `chomp' to the result
" 
  (and f (file-exists-p f)
       (save-window-excursion
	 (let ((b (zap-buffer " *tmp*")) s)
	   (insert-file-contents f)
	   (setq s (buffer-string))
	   (kill-buffer b)
	   (if chomp s (chomp s)))
	 )
       )
  )



(defvar backup-file-extension ".bak")
(defun backup-file (fn)
  " save prior version of FILE if any"

  (and fn (file-exists-p fn)
       (rename-file fn (concat fn backup-file-extension) t))
  )
