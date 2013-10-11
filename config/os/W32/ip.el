; there's probably a better way to do this

(defvar *ipconfig-line-tag*  "IPv4 Address")

(defun ipaddress ()
  (interactive)
  (let* ((ret (eval-process "ipconfig"))
	 (addrs (loop for line in (split ret "[\r]?\n")
		      when (string-match *ipconfig-line-tag* line)
		      collect (cadr (split line "[ ]*:[ ]*")))))
    (if 
	(called-interactively-p 'any)
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

