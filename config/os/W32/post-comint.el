(put 'post-comint 'rcsid
 "$Id: post-comint.el,v 1.1 2004-03-14 21:50:05 cvs Exp $")

(chain-parent-file t)

; workaround issues with cygwin signal passing
(defun interrupt-subjob () (interactive)
  (and (eq major-mode 'shell-mode)
       (let ((p (buffer-process)))
	 (if (process-running-child-p p)
	     (let* ((pid (process-id (buffer-process)))
		   (l (processes))
		   (r (loop for x in l when (= (elt x 1) pid) collect x))
		   (s (and r (eval-process "kill" "-15" (format "%d" (caar r))))))
	       (if (not (interactive-p)) s
		 (message s))
	       )
	   )
	 )
       )
  )

(define-key shell-mode-map "" 'interrupt-subjob)
