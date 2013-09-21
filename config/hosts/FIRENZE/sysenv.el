(defun sysenv ()
  (interactive)
  (call-process "control.exe" nil nil nil "sysdm.cpl,System,3")
  )

; (call-interactively 'sysenv)
(define-key ctl-RET-map "\C-e" 'sysenv)

