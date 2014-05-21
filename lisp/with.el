
; see os-init.  probably should promote to there

(unless (boundp '*systemdrive*)
  (defvar *systemdrive* (expand-file-name (or (getenv "SYSTEMDRIVE") "/"))))

; mainly for eval when current drive not = systemdrive

(defmacro with-default-directory (&optional dir &rest body)
  "Execute the forms in BODY with dir as the current `default-directory'.
The value returned is the value of the last form in BODY."
  `(let ((default-directory (or ,dir ,*systemdrive*)))
     ,@body)
  )

; the following should hold regardless of which drive current directory is on: 
; (assert (string= (with-default-directory nil (expand-file-name "/")) (expand-file-name "/" (getenv "SYSTEMDRIVE"))))


(provide 'with)
