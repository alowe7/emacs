(defun which (cmd) (eval-shell-command (format "which %s" cmd)))
(defvar *lsinstall* (which "lsinstall"))

(defun lsinstall ()
  (interactive)
  (let ((bn "*lsinstall*")) 
    (with-output-to-temp-buffer bn
      (princ (eval-process (format "%s %s" *perl-command* *lsinstall*)))
      )
   ; (switch-to-buffer bn)
    )
  )
; (call-interactively 'lsinstall)
