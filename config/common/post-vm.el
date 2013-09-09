(put 'post-vm 'rcsid 
 "$Id$")

(defun dired-vm-file ()
  "run vm on specified file"
  (interactive)
  (or (fboundp 'vm-visit-folder) (require 'vm))
  (vm-visit-folder (dired-get-filename))
  )

(add-hook 'dired-mode-hook 
	  (lambda nil 
	     (define-key  dired-mode-map "v" 'dired-vm-visit-folder)
))

; (vm-apply-window-configuration (quote vm-summarize))
(define-key vm-summary-mode-map "u" 'vm-summarize)
; vm-folders-summary-mode-map
; vm-edit-message-map
; vm-mail-mode-map
