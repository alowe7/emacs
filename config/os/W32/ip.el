; there's probably a better way to do this

(defun ipaddress ()
  (interactive)
  (let* ((ret (eval-process "ipconfig"))
	 (addrs (loop for line in (split ret "[\r]?\n")
		      when (string-match "IP Address" line)
		      collect (cadr (split line "[ ]*:[ ]*")))))
    (if 
	(interactive-p)
	(message 
	 (cond
	  ((null addrs) "")
	  ((= (length addrs) 1) (car addrs))
	  (t (join addrs ", "))
	  )
	 )
      addrs)
    )
  )
; (ipaddress)
; (call-interactively 'ipaddress)

