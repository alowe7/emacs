(put 'regtool 'rcsid
 "$Id: regtool.el,v 1.1 2006-05-22 15:01:12 alowe Exp $")

; see reg.el

(defun regtool (action key &optional options) 
  "evaluates to result of running regtool."

  (interactive (list 
		(completing-read "action: " '(("add" "add") ("get" "get") ("list" "list") ("set" "set")) nil t)
		(read-string "key: ")
		(string* (read-string "options: "))))

  (eval-process "regtool" action key)
  )

; (regtool "get" "/HKLM/SOFTWARE/Technology X/tw/wtop")

(provide 'regtool)
