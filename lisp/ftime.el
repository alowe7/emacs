(put 'ftime 'rcsid
 "$Id: ftime.el,v 1.1 2005-03-01 20:13:12 cvs Exp $")

;; where does this really belong?
(defun ftime () (interactive)
	"display formatted time string last modification time of file for current buffer"
  (let* ((fn (buffer-file-name))
	(f (and fn (elt (file-attributes fn) 5))))
    (message (if f
	(clean-string (eval-process "mktime" (format "%d" (car f)) (format "%d" (cadr f))))
	"no file")
	)
    )
  )
