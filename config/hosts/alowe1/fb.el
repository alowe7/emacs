(put 'fb 'rcsid
 "$Id: fb.el,v 1.1 2003-12-09 22:36:26 cvs Exp $")

; this module overrides some functions defined in fb.el

(chain-parent-file t)

(require 'xdb)
(let ((load-path (nconc '(".") load-path))) (require 'xq))

(defun regexp-to-sql (pat)
  (tr pat '((?* "%")))
  )

(defvar *ff-pop-to-singleton* nil)

(defun ffsql (pat)
  (interactive (list (string* (read-string (format "pattern (%s): " (current-word))) (current-word))))

  (let ((pat (funcall ff-hack-pat pat))
	(b (zap-buffer *fastfind-buffer*))
	(s (string* (xq* (format "select name from f where name like '%s'" 
				 (let ((pat pat))
				   (setq pat (if (string= (substring pat -1) "$")
						 (substring pat 0 -1)
					       (concat pat "%")))
				   (setq pat (if (string= (substring pat 1) "^")
						 (substring pat 1)
					       (concat "%" pat)))
				   )))))
	)

    (setq *find-file-query*
	  (setq mode-line-buffer-identification 
		pat))

    (set-buffer b)
    (insert s)

    (goto-char (point-min))
    (fb-mode)

    (run-hooks 'after-find-file-hook)

    (if *ff-pop-to-singleton*
	(let ((l (split s "
")))
	  (cond ((and (interactive-p) (= (length l) 1))
		 (find-file (car l)))
		((interactive-p)
		 (pop-to-buffer b))
		(t l))
	  )
      (pop-to-buffer b)
      )
    )
  )

; supercedes `ff'
(defalias 'off (symbol-function 'ff))
(defalias 'ff 'ffsql)

(provide 'ffsql)
