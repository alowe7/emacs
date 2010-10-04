(put 'domainname 'rcsid
 "$Id$")

; obsolete, and wrong anyway

(defun domainname () 
  (clean-string (reg-query "machine" 
			   "system/currentcontrolset/services/tcpip/parameters" "domain"))
  )
