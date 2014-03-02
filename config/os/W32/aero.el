(defvar *rundll* (canonify (substitute-in-file-name "$WinDir/System32/rundll32.exe")))

(defun flip-3d ()
  (interactive)
  (call-process *rundll* nil nil nil "dwmapi" "#105")
  )


