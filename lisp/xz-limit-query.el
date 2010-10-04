(put 'xz-limit-query 'rcsid
 "$Id$")

(defun xz-limit-query (query limit)
  "frame an xz query on QUERY, format and pop to hit buffer
 if QUERY is a list, interpret it as query result and format that instead
"
  (interactive (list 
		(let ((s (read-string (format "query (%s): " (indicated-word)))))
		  (or (and (> (length s) 0) s) (indicated-word)))
		(string-to-number (read-string "limit: ")) ))

  (if (eq (catch 'ka-boom ; handle crashes
  ; frame query
	    (let* ((l (if (listp query) query (xz-issue-query query)))
		   (b (xz-format-list (if (< (length l) limit) l (progn (rplacd (nthcdr limit l) nil) l))))
		   (id (if (stringp query) query ""))
		   )
	      (cond ((stringp b)
		     (message b))
		    ((bufferp b)
		     (pop-to-buffer b)
		     (beginning-of-buffer)
		     (setq mode-line-buffer-identification query)
		     (setq truncate-lines t)
		     (set-buffer-modified-p nil))
		    (t
		     (message "no matches")))
	      )
	    ) t)
      (message "xz crashed.")
    (run-hooks 'xz-after-search-hook)
    )
  )

(define-key xz-map (vector 67108912) 'xz-limit-query)
