(put 'fb 'rcsid
 "$Id: fb.el,v 1.12 2004-11-08 14:45:20 cvs Exp $")

; this module overrides some functions defined in fb.el

(chain-parent-file t)

(require 'xdb)
(let ((load-path (nconc '(".") load-path))) (require 'xq))

(defun regexp-to-sql (pat &optional exact)
  "simpleminded conversion of PAT from regexp syntax to sql syntax.
wraps in wildcards unless optional EXACT is set.
otherwise, converts '*' to '%' and '.' to '_'

pattern may also contain environment variables
"

  (unless exact
    (progn 
      (setq pat (cond ((eq (aref pat 0) ?^) 
		       (substring pat 1))
		      ((string-match  "^&[/]*" pat)
		       (concat "/./%" (substring pat (match-end 0)))) ; not really regexp anymore
		      ((eq (aref pat 0) ?$)
		       pat)
		      (t
		       (concat "%" pat))))
      (setq pat (if (eq (aref pat (1- (length pat))) ?$) (substring pat 0 -1) (concat pat "%")))))

  (condition-case err
      (setq pat 
  ;	    (canonify 
	    (substitute-in-file-name pat)
  ;	    0)
	    )
; attempting to substitute non-existent environment variables is a bad idea.
; remind me to hack the emacs source: (substitute-in-file-name FILENAME &optional noerror)
    (error pat))

  (tr pat '((?* "%") (?. "_")))

  )
; (regexp-to-sql "$NOTTHERE")


(defun ffsql (pat)
  "find files matching REGEXP.
this version of ff queries a sql db somewhere using `xq*'
regexp is converted from regular expression syntax to sql syntax internally.
if regexp contains environment variables, they are expanded.
"

  (interactive (list (string* (read-string (format "find files matching pattern (%s): " (indicated-filename))) (indicated-filename))))

  (let* ((ff-hack-pat 'regexp-to-sql)
  ; hack pat first to avoid collision with regexp $ and environment variable substitution
	 (pat (substitute-in-file-name (funcall ff-hack-pat pat)))
	 (query (format "select name from f where name like '%s'" pat))
	 (s (xq* query))
	 )

    (cond ((string* s)
	   (let ((b (zap-buffer-2 *fastfind-buffer*)))

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
		    (let ((w (get-buffer-window b)))
		      (or (and w (select-window w))
			  (pop-to-buffer b))))
  ; else just return the list
		   (t (split (buffer-string) "
")
		      ))
	     ))
	  ((interactive-p)
  ; not (string* s)
	   (message "no files matching <%s> found." pat))
	  )
    )
  )

; supercedes `ff'
(defalias 'off (symbol-function 'ff))
(defalias 'ff 'ffsql)

(provide 'ffsql)
