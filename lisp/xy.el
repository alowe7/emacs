
; kind of a version of zz for cs code

; tbd compare with zz.locate-def 

(defvar *searchpat* "%s*%s\\.cs") 

;; see locate1 in post-locate.el and also zz.el
(defvar *top* (let ((top "/projects")) (if (file-directory-p top) top (expand-file-name "~"))))

(defun find-definition (&optional arg)
  (interactive "P")

  (let* (
	 (sym (cond ((stringp arg) arg) (arg (read-string* "search for (%s): " (thing-at-point 'symbol)))))
	 (symbol (or sym (thing-at-point 'symbol)))
	 (ret
	  (eval-process "locate"
			(format *searchpat* *top* symbol)))
	 (l (split ret "\n"))
	 (choice
	  (cond
	   ((= (length l) 0) (message "not found"))
	   ((= (length l) 1) (car l))
	   (t
	    (roll-list l)
					;	  (completing-read* "choose (%s): " (car l) (loop for a in l collect (list a a)))
	    ))) 
	 )
    (if (string* choice)
	(progn
	  (find-file choice)
	  (goto-char (point-min))
	  (when (re-search-forward 
		 (format "\\(Interface\\ \\|Class\\s \\)\\(%s\\)\\s " symbol)
		 nil t)
	    (goto-char (match-beginning 2)))
	  (message "")
	  )
      (message (format "symbol '%s' not found in %s" symbol *top*))
      )
    )
  )

; (find-definition "IMyInterface")

(define-key ctl-\\-map "\C-i" 'find-definition)
