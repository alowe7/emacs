
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
