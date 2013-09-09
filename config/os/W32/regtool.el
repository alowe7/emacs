(put 'regtool 'rcsid
 "$Id$")

(require 'eval-process)

; see reg.el

(defun regtool (action key &optional options) 
  "evaluates to result of running regtool."

  (interactive (list 
		(completing-read "action: " '(("add" "add") ("get" "get") ("list" "list") ("set" "set")) nil t)
		(read-string "key: ")
		(string* (read-string "options: "))))

  (apply 'eval-process   
  ; tbd figure out why this is necessary
	 (if options
	     (list "regtool" action key options)
	   (list "regtool" action key)
	   )
	 )
  )

; (regtool "get" "/HKLM/SOFTWARE/Technology X/tw/wtop")

(provide 'regtool)
