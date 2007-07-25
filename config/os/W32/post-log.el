(put 'post-log 'rcsid
 "$Id: post-log.el,v 1.2 2007-07-25 16:13:11 alowe Exp $")

(require 'regtool)

(defun vl () 
  (interactive)
  (let* ((wtop (regtool "get" "/HKLM/SOFTWARE/Technology X/tw/wtop"))
         (wbase (regtool "get" "/HKLM/SOFTWARE/Technology X/tw/wbase"))
         (logfile (format "%s/%s/log" wtop wbase))
         (b (get-file-buffer logfile))
         (w (and b (get-buffer-window b)))
         )
    (cond (w
           (select-window w)
           (revert-buffer nil t)
           )
          (b
           (set-buffer b)
           (revert-buffer nil t)
           (switch-to-buffer b))
          ((file-exists-p logfile) 
	   (find-file logfile)
	   (logview-mode)
	   (end-of-buffer))
	  (t (message "%s not found" logfile)))
    )
  )



