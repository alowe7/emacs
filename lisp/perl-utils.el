(put 'perl-utils 'rcsid 
 "$Id: perl-utils.el,v 1.3 2000-10-03 16:50:28 cvs Exp $")

; perl workalike functions

(defun chop (s &optional c)
  "maybe chop trailing linefeed"
  (if (eq (aref (substring s -1) 0) (or c ?
					)	  ) (substring s 0 -1) s)
  )

;; I think these are obsolete
(defun split-list (l p)
  "split environment list l at item p, if found.
 return list of lists l1, l2 "
  (interactive)

  (let ((len (length p)) (a l) (a1 nil) (a2 nil))
    (while a
      (if (and (string-match p (car a)) (= (match-end 0) len))
	  (progn (setq a2 (cdr a)) (setq a nil))
	(progn (setq a1 (append a1 (list (car a)))) (setq a (cdr a))))
      )
    (cons a1 a2)
    )
  )


;; finds first occurrence of f along p
(defun wis (p f) (interactive)
  (let ((f (concat (car p) "/" f)))
    (if (file-exists-p f) f (wis (cdr p) f))))
