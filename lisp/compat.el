(put 'compat 'rcsid
 "$Id: compat.el,v 1.1 2006-02-08 15:45:22 alowe Exp $")

(if (fboundp 'replace-regexp-in-string)
  ; some other genius at fsf finally decided this would be a good idea
    (fset 'replace-in-string 'replace-regexp-in-string)
  ; you're on a version that doesn't have it.  add ignored optional parms to avoid runtime errors
  (defun replace-in-string (from to str  &optional fixedcase literal subexp start)
    "replace occurrences of REGEXP with TO in  STRING" 
    (save-match-data
      (if (string= from "^")
	  (concat to (replace-in-string "
" (concat "
" to) str)) 
	(let (new-str
	      (sp 0)
	      )
	  (while (string-match from str sp)
	    (setq new-str (concat new-str (substring str sp (match-beginning 0)) to))
	    (setq sp (match-end 0)))
	  (setq new-str (concat new-str (substring str sp)))
	  new-str))
      )
    )
  )

(provide 'compat)
