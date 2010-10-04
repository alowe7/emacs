(put 'props 'rcsid
 "$Id$")

(defun vars-with-prop (prop)
  (interactive "Sproperty: ")
  (let ((b (zap-buffer "*props*")))
    (loop for x being the symbols 
	  with r = nil
	  when (and (setq r (get x prop)) (stringp r))
	  do (insert (format "%36s\t%s\n" x r))
	  )
    (set-variable 'truncate-lines t)
    (pop-to-buffer b)
    (beginning-of-buffer)
    (view-mode))
  )


; (vars-with-prop 'rcsid)
