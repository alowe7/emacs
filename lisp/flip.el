(put 'flip 'rcsid "$Id: flip.el,v 1.4 2000-10-03 16:44:06 cvs Exp $")

; microsoft has some funny ideas about these chars
(defun flip ()
  (interactive)
  (save-excursion
    (while
        (search-forward "\C-m" nil t)
      (backward-delete-char 1)
      )
    (while
	(search-forward "\C-z" nil t)
      (backward-delete-char 1)
      )
    ))
