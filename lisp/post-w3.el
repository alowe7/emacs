
(defun dired-w3-file () 
  (interactive)
  (or (fboundp 'w3) (require 'w3))
  (w3-fetch (format "file://%s" (dired-get-filename)))
  )

(add-hook 'dired-mode-hook 
	  '(lambda nil 
	     (define-key dired-mode-map "w" 'dired-w3-file)
))

(global-set-key  "v" 'w3-open-local)
