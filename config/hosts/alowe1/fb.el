(put 'fb 'rcsid
 "$Id: fb.el,v 1.4 2004-01-30 14:47:04 cvs Exp $")

; this module overrides some functions defined in fb.el

(chain-parent-file t)

(require 'xdb)
(let ((load-path (nconc '(".") load-path))) (require 'xq))

(defun regexp-to-sql (pat)
  (setq pat (if (eq (aref pat 0) ?^) (substring pat 1) (concat "%" pat)))
  (setq pat (if (eq (aref pat (1- (length pat))) ?$) (substring pat 0 -1) (concat pat "%")))
  (tr pat '((?* "%")))
  pat
  )

(defun ffsql (pat)
  (interactive (list (string* (read-string (format "find files matching pattern (%s): " (current-word))) (current-word))))

  (let* ((ff-hack-pat 'regexp-to-sql)
	 (pat (funcall ff-hack-pat pat))
	 (query (format "select name from f where name like '%s'" pat))
	 (s (xq* query))
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

  ; try to avoid splitting (buffer-string) 
	  (cond ((and *fb-auto-go* 
		      (interactive-p) 
		      (= (count-lines (point-min) (point-max)) 1)
		      (not (probably-binary-file (bgets))))
  ; pop to singleton if appropriate
		 (find-file (car (split (buffer-string) "
"))))
  ; else pop to listing if interactive
		((interactive-p)
		 (pop-to-buffer b))
  ; else just return the list
		(t (split (buffer-string) "
")
		   ))
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
