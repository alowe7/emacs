; change control system hooks
(add-hook
 'world-pre-change-hook
 '(lambda ()
		(setenv "CBASEDIR")
		(setenv "CNAME")
		))

(defun ec (c)
	(interactive 
	 (list
		(completing-read (format "change (%s): " (getenv "CNAME"))
										 (mapcar 'list (get-directory-files ($ "$W/CCS"))))))

	(dired ($ (concat "$W/CCS/" 
										(if (> (length c) 0) c (getenv "CNAME"))))))
(defun es (c)
	(interactive 
	 (list
		(completing-read (format "change (%s): " (getenv "CNAME"))
										 (mapcar 'list (get-directory-files ($ "$W/CCS"))))))

	(setenv "CNAME" c))


(defun eh (s) (interactive "scomment: ")
	(write-region (concat (current-time-string) "\n" s) nil 
								($ (concat "$W/CCS/" (getenv "CNAME") "/history")) t))

(defun ew () (interactive)
	(message (getenv "CNAME")))


(provide 'ccs)