(put 'domainname 'rcsid
 "$Id: domainname.el,v 1.1 2006-04-13 15:39:05 nathan Exp $")

; obsolete, and wrong anyway

(defun domainname () 
  (clean-string (reg-query "machine" 
			   "system/currentcontrolset/services/tcpip/parameters" "domain"))
  )
