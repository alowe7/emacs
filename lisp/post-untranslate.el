(defconst rcs-id "$Id: post-untranslate.el,v 1.3 2000-07-30 21:07:47 andy Exp $")

(defun fix-dos-file ()
  (interactive)
  (save-excursion
    (while
        (search-forward "\C-m" nil t)
      (backward-delete-char 1)
      )
    (while
        (search-forward "\C-z" nil t)
      (backward-delete-char 1)
      )))


