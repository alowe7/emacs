(put 'post-untranslate 'rcsid "$Id: post-untranslate.el,v 1.4 2000-10-03 16:44:07 cvs Exp $")

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


