(put 'fb 'rcsid
 "$Id: fb.el,v 1.2 2003-12-15 22:46:30 cvs Exp $")

; this module overrides some functions defined in fb.el

(chain-parent-file t)

(require 'xdb)
(let ((load-path (nconc '(".") load-path))) (require 'xq))

(defun regexp-to-sql (pat)
  (tr pat '((?* "%")))
  )

(defun ffsql (pat)
  (interactive (list (string* (read-string (format "pattern (%s): " (current-word))) (current-word))))

  (let* ((ff-hack-pat 'regexp-to-sql)
	 (pat (funcall ff-hack-pat pat))
	 (s (string* (xq* (format "select name from f where name like '%%%s%%'" 
				  (let ((pat pat))
				    (setq pat (if (string= (substring pat -1) "$")
						  (substring pat 0 -1)
						(concat pat "%")))
				    (setq pat (if (string= (substring pat 1) "^")
						  (substring pat 1)
						(concat "%" pat)))
				    )))))
	 )

    (if (string* s)
	(let ((b (zap-buffer *fastfind-buffer*)))

	  (setq *find-file-query*
		(setq mode-line-buffer-identification 
		      pat))

	  (insert s)

	  (goto-char (point-min))
	  (fb-mode)

	  (run-hooks 'after-find-file-hook)

	  (let ((l (split s "
")))
  ; pop to singleton if appropriate
	    (cond ((and *fb-auto-go*
			(interactive-p)
			(= (length l) 1)
			(not (probably-binary-file (car l))))
		   (find-file (car l)
			      )
		   )
  ; else pop to listing if interactive
		  ((interactive-p) 
		   (pop-to-buffer b)
		   )
  ; else just return the list
		  (t l))
	    )
	  )
  ; not (string* s)
      (message "no files matching <%s> found." pat)
      )
    )
  )

; supercedes `ff'
(defalias 'off (symbol-function 'ff))
(defalias 'ff 'ffsql)

(provide 'ffsql)
