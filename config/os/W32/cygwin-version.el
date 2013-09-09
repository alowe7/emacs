;; maybe it would be better to comb the registry.
(cond ((string-match "1.3.2" (eval-process "uname" "-r"))

       ;; mount output format for (beta) release 1.3.2
       (defun cygmounts ()
	 " list of cygwin mounts"
	 (setq cygmounts
	       (loop for x in (split (eval-process "mount") "
")
		     collect 
		     (let ((l (split x " ")))
		       (list (caddr l) (car l))))
	       )
	 )
       )
      ((string-match "1.5" (eval-process "uname" "-r"))
;;  this was originally intended to catch interminable timeouts on disconnected drives
       (defun cygmounts () (setq cygmounts nil))
       )
      (t 
       ;; mount output format for release 1.0
       (defun cygmounts ()
	 " list of cygwin mounts"
	 (setq cygmounts
	       (loop for x in (cdr (split (eval-process "mount") "
"))
		     collect
		     (let
			 ((l (split (replace-regexp-in-string "[ ]+" " " x))))
		       (list (cadr l) (car l))))
	       )
	 )
       )
      )
