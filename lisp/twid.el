(put 'twid 'rcsid
 "$Id: twid.el,v 1.1 2004-03-27 19:03:09 cvs Exp $")

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
