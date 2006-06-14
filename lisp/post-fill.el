(put 'post-fill 'rcsid
 "$Id: post-fill.el,v 1.2 2006-06-14 20:34:42 alowe Exp $")

;; moved from w32

(defun hard-fill  (from to)
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
