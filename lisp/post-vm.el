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
