
(defun xz-find-function-def (string)
  (interactive "sgoto function definition: ")

  (xz-query-format
   (let* ((query (concat "./fd" (or (and (> (length string) 0) string) (indicated-word))))
	  (l (xz-issue-query query)))
     ; (debug)
     (loop for x in l when (string-match "\.cpp$" (cadr x)) collect x)
     )
   )
  )

(define-key xz-map "" 'xz-find-function-def)
