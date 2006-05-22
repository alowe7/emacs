(put 'post-log 'rcsid
 "$Id: post-log.el,v 1.1 2006-05-22 15:01:12 alowe Exp $")

(require 'regtool)

(defun vl () 
  (interactive)
  (let* ((wtop (regtool "get" "/HKLM/SOFTWARE/Technology X/tw/wtop"))
	(wbase (regtool "get" "/HKLM/SOFTWARE/Technology X/tw/wbase"))
	(logfile (format "%s/%s/log" wtop wbase))
	)
    (cond ((file-exists-p logfile) 
	   (find-file logfile)
	   (logview-mode)
	   (end-of-buffer))
	  (t (message "%s not found" logfile)))
    )
  )



