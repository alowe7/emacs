(put 'post-untranslate 'rcsid 
 "$Id: post-untranslate.el,v 1.1 2004-01-10 16:26:44 cvs Exp $")

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

