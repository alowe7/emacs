(put 'twid 'rcsid
 "$Id$")

(defun find-source ()
  (interactive)
  (let* ((feature (save-excursion
		    (beginning-of-buffer)
		    (search-forward "(provide ")
		    (intern (indicated-word))))
	 (w (and feature (fw (get feature 'tw))))
	 (rcsid (and w (get feature 'rcsid))))
    (if rcsid
	(find-file (concat w "/site-lisp" "/" (replace-in-string ",v$" "" (cadr (split rcsid)))))
      (message "not found"))
    )
  )
(fset 'twid 'find-source)
