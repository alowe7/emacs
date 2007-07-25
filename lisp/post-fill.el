(put 'post-fill 'rcsid
 "$Id: post-fill.el,v 1.3 2007-07-25 16:13:11 alowe Exp $")

;; moved from w32

(defun hard-fill (from to)
  (interactive "r")
  (goto-char from)
  (while (search-forward  "
" nil t)
    (replace-match  "

" nil t))

  (fill-nonuniform-paragraphs from to nil)
  )

(defun soft-fill-region (from to)
  (interactive (list (region-beginning) (region-end)))
  (call-interactively 'trim-white-space)
  (let ((a (min from to)) (b (max from to)))
    (dolist (x '(
		 ("

" "|")
		 ("
" " ")
		 ("|" "

")))
      (goto-char a)
      (while (search-forward (car x) b t)
	(replace-match (cadr x) t))
      )
    ))

(global-set-key "" 'soft-fill-region)

(provide 'soft-fill)
(provide 'hard-fill)
