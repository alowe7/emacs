
; xxx unfortunately named.
(defun replace-in-string (from to str)
  "replace occurrences of REGEXP with TO in  STRING" 
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