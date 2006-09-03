(put 'zz 'rcsid
 "$Id: zz.el,v 1.1 2006-09-03 15:42:15 tombstone Exp $")

; poor blind man's xz

(defun regexp-to-find (regexp)
  (concat "\\( " 
	  (join 
	   (loop for x in (split regexp "|")
		 collect
		 (format "-name \"*.%s\"" x)
		 )
	   " -o ")
	  " \\)")
  )
; (regexp-to-find "a|b|c")

(defun zz (thing &optional pat)
  "run grep-find for THING, specifying optional PAT
"
  (interactive
   (list (read-string* "grep-find (%s): " (thing-at-point 'word))
	 (and current-prefix-arg (read-string* "pat (%s): " "c|el|java"))))

  (let* (
	 (pat (or pat "c|el|java"))
	 (filenamepattern (regexp-to-find pat))
	 (cmd (format "find . -type f %s -print0 | xargs -0 -e grep -n -e %s" filenamepattern thing)))

    (grep-find cmd)
    )
  )

; (zz "find_auth_user_passwd")
(define-key ctl-RET-map "\C-@" 'zz)
