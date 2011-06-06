(require 'comint)

; cryptic ain't we?
(put '\ *key 'swordfish "/a/.private/swords")

(defun key (pat)
  (interactive "P")

  (if (and pat (listp pat))
      (put '\ *key 'swordfish (read-string "swordfish: ")) 
    )

  (let* ((keycmd "key")
	 (pat (read-string "pat: "))
	 (key (or (get (intern swordfish) '\ *key*)
		  (comint-read-noecho "key: " t)))
	 )
    (shell-command (format "%s -k %s -d %s | grep %s" keycmd key 
			   (get '\ *key 'swordfish)
			   pat) )
    (put (intern swordfish) '\ *key* key)
    )
  )

;


