(put 'post-untranslate 'rcsid 
 "$Id$")

(defun fix-dos-file ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while
        (search-forward "\C-m" nil t)
      (backward-delete-char 1)
      )
    (while
        (search-forward "\C-z" nil t)
      (backward-delete-char 1)
      )))
(fset 'dos-fix-file 'fix-dos-file)



