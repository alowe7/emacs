(put 'path-utils 'rcsid
 "$Id: path-utils.el,v 1.2 2008-09-27 21:49:35 keystone Exp $")

(defun addpathp (element path)
  " add ELEMENT to environment variable named PATH if not already on it
for example: (addpathp \"/bin\" \"PATH\")
"
  (let ((element (expand-file-name element))
	(element1
	 (if (and (boundp 'window-system) (eq window-system 'w32))
	     (w32-canonify element)
	   element)))
    (unless 
	(loop for x in (split (getenv path) path-separator) thereis (string-equal x element1))
   	     (setenv path (concat (getenv path) path-separator element1))
	     )
      )
  )

(provide 'path-utils)
