(put 'fb 'rcsid
 "$Id: fb.el,v 1.14 2005-01-03 19:56:59 cvs Exp $")

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


(defun ffsql (pat &optional filter show)
  "find files matching REGEXP.
this version of ff queries a sql db somewhere using `xq*'
regexp is converted from regular expression syntax to sql syntax internally.
if regexp contains environment variables, they are expanded.

optional arg FILTER is a function applied to matching files.
this function accepts a string and returns a string or nil.

when called from a program, this function merely returns the results as a list.
with optional arg SHOW, displays the list as if it had been called interactively.
"

  (interactive (list 
		(let ((default-filename (indicated-filename)))
		  (string* (read-string (format "find files matching pattern (%s): " default-filename)) default-filename))))

  (let* ((ff-hack-pat 'regexp-to-sql)
  ; hack pat first to avoid collision with regexp $ and environment variable substitution
	 (pat (substitute-in-file-name (funcall ff-hack-pat pat)))
	 (query (format "select name from f where name like '%s'" pat))
	 (s (xq* query))
	 )

    (if filter
	(setq s (join
		 (remove* nil 
			  (loop for x in (split s "
")
				collect (funcall filter x)))
		 "
")
	      )
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
			 (or show (interactive-p))
			 (= (count-lines (point-min) (point-max)) 1)
			 (not (probably-binary-file (bgets))))
  ; pop to singleton if appropriate
		    (find-file (car (split (buffer-string) "
"))))
  ; else pop to listing if interactive
		   ((or show (interactive-p))
		    (let ((w (get-buffer-window b)))
		      (or (and w (select-window w))
			  (pop-to-buffer b))))
  ; else just return the list
		   (t (split s)))
	     ))
	  ((or show (interactive-p))
  ; not (string* s)
	   (message "no files matching <%s> found." pat))
	  )
    )
  )

; supercedes `ff'
(defalias 'off (symbol-function 'ff))
(defalias 'ff 'ffsql)

(provide 'ffsql)
