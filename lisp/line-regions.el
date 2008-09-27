(put 'line-regions 'rcsid
 "$Id: line-regions.el,v 1.1 2008-09-27 16:34:01 keystone Exp $")

(defun point-at-line (n)
  "return point at beginning of line N  or `point-max' whichever is less.
if N is negative, count from end.
"
  (let ((start (if (> n 0) (point-min) (point-max))))
    (save-excursion
      (goto-char start)
      (forward-line n)
      (point)
      )
    )
  )
; (point-at-line 0)
; (point-at-line 10)
; (point-at-line -2)

(defun mark-lines (from to)
  "return region consisting of lines between FROM and TO or `point-max' whichever is less.
lines count from 0
"
  (list (point-at-line from) (max (point-min) (1- (point-at-line to))))
  )
; (apply 'narrow-to-region (mark-lines 2 -2))

(provide 'line-regions)
