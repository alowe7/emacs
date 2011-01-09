(put 'xz-constraints 'rcsid
 "$Id$")

(defvar *xz-constrain-queries* t "if set, enables constrained queries.  see `xz-issue-query' for constraints")
(defvar *xz-last-constraint* nil)


(defun xz-fancy-constraints (s)
"document me"
  (cond ((or (not s) (<= (length s) 0))
	 *xz-last-constraint*)
	((string= s "?") 
	 (progn
	   (message "?: help ,:matches filename .:match dir ..:match parent -: clear")
	   (sit-for 1 250)
	   (xz-fancy-constraints (read-string "constraint: "))))
	((string= s ",") f);; matches filename
	((string= s ".") d);; match current dir
	((string= s "..") (concat dd "/" d));; match parent dir
	((string= s "...") (concat ddd "/" dd "/" d));; match up 2 dir
	((string= s "-") nil);; clear
	(t s))
  )

(defun xz-constrained-query-format (string &optional constraint)
  "frame an xz query on STRING, with optional CONSTRAINT.
format and pop to hit buffer.
see `xz-issue-query' for descriptions of string and constraint
"
  (interactive (list 
		(let ((s (read-string (format "constrained query (%s): " (indicated 'symbol)))))
		  (or (and (> (length s) 0) s) (indicated 'symbol)))
		(let* ((splat (reverse (split (buffer-file-name) "/")))
		       (f (car splat))
		       (d (cadr splat))
		       (dd (caddr splat))
		       (ddd (cadddr splat))
		       (s (read-string (format "constraint (%s): " *xz-last-constraint*))))
		  (setq *xz-last-constraint* (xz-fancy-constraints s))
		  )))

  (if (eq (catch 'ka-boom ; handle crashes
  ; frame query
	    (let ((b (xz-format-list 
		      (xz-issue-query string constraint))))
	      (cond ((stringp b)
		     (message b))
		    ((bufferp b)
		     (pop-to-buffer b)
		     (goto-char (point-min))
		     (setq mode-line-buffer-identification string)
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

(defun xz-query-format-1 (query &optional query-function) 

  (interactive (list 
		(let ((s (read-string (format "query (%s): " (indicated 'symbol)))))
		  (or (and (> (length s) 0) s) (indicated 'symbol)))))

  (xz-query-format query query-function)
  )

(defun xz-constrained-query-format-1 (arg) 
  "if `*xz-constrain-queries*' is set, calls `xz-constrained-query-format'
with optional prefix arg, prompts to specify the constraint.
otherwise calls `xz-query-format'"
  (interactive "P") 
  (call-interactively (if (and *xz-constrain-queries* arg)
			  'xz-constrained-query-format
			'xz-query-format-1))
  )

(define-key xz-map (vector 67108896) 'xz-constrained-query-format-1)
; (define-key xz-map (vector 67108896) 'xz-query-format)

(provide 'xz-constraints)

