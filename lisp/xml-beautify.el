(put 'xml-beautify 'rcsid
 "$Id: xml-beautify.el,v 1.1 2002-06-06 17:17:25 cvs Exp $")

(setq xml-beautify-tags '("<worknodes" "<rawData" "<IDictionaryRoot"))

(defun xml-beautify () (interactive)
  (save-excursion
    (replace-string "><" ">
<" )
    )
  )


(defun maybe-beautify ()
  (save-excursion
    (goto-char (point-min))
    (cond ((search-forward "<IDictionaryRoot" nil t)
  ; yep, its a config, beautify it
	   (beautify-config))
((search-forward "<VTIReport" nil t)
  ; yep, its a config, beautify it
	   (beautify-report))
      )))

(add-hook 'sgml-mode-hook 'maybe-beautify)

(defun beautify-report () 
  (interactive)
  (save-excursion
    (loop for x in '(( "^[ 	]+" . "" )  
		     ("&gt;" . ">")
		     ("&lt;" . "<")
		     ("&quot;" . "\"")
		     ( "><" . ">
<")
		     ) 
	  do
	  (goto-char (point-min))
	  (while (re-search-forward (car x) nil t)
	    (replace-match (cdr x) nil t)))


    (loop for x in  xml-beautify-tags
	  with n = 0
	  do
	  (setq n (+ n 4))
	  (goto-char (point-min))
	  (if (search-forward x nil t)
	      (beginning-of-line)
	    (let ((p (point)))
	      (sgml-skip-tag)
	      (indent-rigidly p (point) n)
	      )
	    )
	  )
    )
  (lazy-lock-mode)
  (set-buffer-modified-p nil)
  )

(defun beautify-config () 
  (interactive)
  (save-excursion
    (loop for x in '(( "^[ 	]+" . "" )  
		     ( "><" . ">
<")
		     ) 
	  do
	  (goto-char (point-min))
	  (while (re-search-forward (car x) nil t)
	    (replace-match (cdr x) nil t)))

    (loop for x in xml-beautify-tags 
	  with n = 0
	  do
	  (setq n (+ n 4))
	  (goto-char (point-min))
	  (if (search-forward x nil t) 
	      (progn
		(beginning-of-line)
		(let ((p (point)))
		  (sgml-skip-tag)
		  (indent-rigidly p (point) n)
		  )
		)
	    )
	  )
    )
  (lazy-lock-mode)
  (set-buffer-modified-p nil)
  )