(put 'post-untranslate 'rcsid 
 "$Id: post-untranslate.el,v 1.6 2001-07-11 18:10:01 cvs Exp $")

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


