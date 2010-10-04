(put 'post-etags 'rcsid 
 "$Id$")

; find-tag-hook

(setq tags-table-list
      '("c:/a/emacs/lisp/TAGS"
	"c:/usr/local/lib/emacs-20.2.1/lisp/TAGS"))

; this says: look for TAGS in current directory first, and then along
; directories in load-path

(defun recompute-tags-table-list () (interactive)
  (setq tags-table-list 
	(cons "."
	      (loop
	       for d in  load-path 
	       if (file-exists-p (concat d "/TAGS"))
	       collect d)))
  )
;(recompute-tags-table-list)

(setq load-path-mod-hook 'recompute-tags-table-list)

(defvar *use-local-tags-table* t "if set, and a tags file exists in
the current directory.  otherwise, just use tags-file-name")

(setq default-tags-table-function
      '(lambda ()
	 (cond ((and *use-local-tags-table* (file-exists-p "TAGS") "TAGS"))
	       (t tags-file-name))))

(defun roll-tags-list () (interactive)
  (let ((d (car tags-table-list)))
    (setq tags-table-list
	  (nconc (cdr tags-table-list) (list d))
	  )
    (or (find-buffer-visiting (concat d "/TAGS"))
	(visit-tags-table (concat d "/TAGS")))
    )
  )

(defun safe-find-tag (tag)  
  (interactive (list (read-string (format "tag (%s): " (indicated-word)))))
  (if (<= (length tag) 0) (setq tag (indicated-word)))
  (if 
      (loop
       for table in tags-table-list
       never
       (unwind-protect
	   (condition-case xyzzy
	       (progn
		 (visit-tags-table table)
		 (find-tag tag))
	     (error nil))))
      (message
       "%s not found along %s" 
       tag 'tags-table-list)
    )
  )

(defun find-tag-on-key (k) (interactive "kKey: ") 
  (message "")
  (let ((b (key-binding k)))
    (cond ((null b) 
	   (message "no binding for %s" (key-description k)))
	  ((and 
	    (symbolp b)
	    (fboundp b)) 
	   (find-tag (symbol-name b)))
	  ((listp b)			; should be a lambda
	   (let ((buf (zap-buffer 
		       (format "*Key Binding for %s*" (key-description k)))))
	     (pp b buf)
	     (pop-to-buffer buf)
	     )
	   )
	  (t (message "non-nil, not a symbol or a list."))
	  )
    )
  )

(defun next-tag () (interactive) (find-tag nil t))

(defun findcmd (cmd)
  "visit file containing COMMAND"
  (interactive "Ccommand: ")
  (catch 'done
    (let ((p load-path)
	  q)
      (while p
	(if (file-exists-p (setq q (concat (car p) "/TAGS"))) (throw 'done q)
	  (setq p (cdr p))))))
  )
