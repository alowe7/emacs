(defconst rcs-id "$Id: post-vm.el,v 1.3 2000-07-30 21:07:47 andy Exp $")
(defun dired-vm-file ()
  "run vm on specified file"
  (interactive)
  (or (fboundp 'vm-visit-folder) (require 'vm))
  (vm-visit-folder (dired-get-filename))
  )

(add-hook 'dired-mode-hook 
	  '(lambda nil 
	     (define-key  dired-mode-map "v" 'dired-vm-visit-folder)
))
