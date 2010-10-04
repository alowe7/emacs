(put 'gendox 'rcsid
 "$Id$")

; would rather do something like: 
;; (loop for x in  '(
;; 		  ("css" "wdgcss" "index.html")     
;; 		  ("html" "html-4.0" "cover.html")
;; 		  ("w3m" "w3m" "doc/MANUAL.html")
;; 		  ("ant" "ant" "docs/manual/toc.html")
;; 		  ("xerces" "xerces" "docs/api.html")
;; 		  )
;;       collect 
;;       (remove* nil (condition-case err
;; 		       (list (car x) (locate-with-filter-1  (cadr x) (caddr x)))
;; 		     (error nil)))
;;       )


(defun cringe (x)
  (let ((case-fold-search t))
    (cond ((string-match "\\(/usr/local/lib/\\|/usr/local/share/doc/\\|/usr/share/doc/\\)\\(.*\\)\\(/index.html\\|/cover.html\\)" x)
	   (replace-regexp-in-string
	    "\\(/manual\\|/html\\|/doc[s]?\\|/faq[s]?\\)"  " "
	    (substring x (match-beginning 2) (match-end 2)))
	   )
	  (t x)
	  )
    )
  )

(defun cringe1 (x)
  (let ((case-fold-search t))
    (cond ((string-match "^/usr" x)
	   (substring x (match-end 0)))
	  (t x)
	  )
    )
  )
(defvar footer "</ul>
]]>

</body>

</blog>
")
(defvar header "<blog>
<title>dox</title>

<body>
<![CDATA[
<ul>
")

(defun gendox ()
  (let ((b (zap-buffer "*dox*" 'html-mode))
	(dox
	 (sort
	  (loop for x in 
		(nconc
		 (locate-with-filter-1 "/usr" "index.html")
		 (locate-with-filter-1 "/usr" "cover.html")
		 )
		when (string* x)
		collect
		(cons (cringe x) (cringe1 x)))
  ; wow.	
	  '(lambda (x y) (let ((x (car x)) (y (car y))) (or (< (length x) (length y)) (and (not (string-match "/" x)) (string-match "/" y)) (string-lessp x y)))))

	 ))

    (set-buffer b)
    (insert header)
    (let (seen)
      (loop for x in dox 
	    unless (or
  ; double wow.
		    (member (car x) seen)
		    (and (string-match "/" (car x)) (let ((x (car (split (car x) "/")))) (and (member x seen) (push x seen)))))
	    do
	    (insert (format "<li><a href=\"%s\">%s</a>\n" (cdr x) (car x)))
	    (push (car x) seen)
	    )
      )
    (insert footer)

    (beginning-of-buffer)
    (set-buffer-modified-p nil)
    (display-buffer b)
    )
  )

; (gendox)
