(defconst rcs-id "$Id: flip.el,v 1.3 2000-07-30 21:07:45 andy Exp $")

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
