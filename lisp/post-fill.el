(put 'post-fill 'rcsid
 "$Id: post-fill.el,v 1.5 2009-11-15 02:12:23 alowe Exp $")

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

(defun soft-fill-paragraph ()
  (interactive)
  (let ((r (bounds-of-thing-at-point 'paragraph)))
    (soft-fill-region (1+ (car r)) (1- (cdr r)))
    )
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

(global-set-key "\C-c\C-x\C-q" 'soft-fill-region)


(defun soft-split-region (from to)
  (interactive "r")
  ; todo: modify trim-white-space et al to take a region or a string

  (save-excursion
    (soft-fill-region from to)
    (replace-string "." ".
" nil from to)
    )
  )

(global-set-key "\C-c\C-x\C-j" 'soft-split-region)


(provide 'soft-fill)
(provide 'hard-fill)
