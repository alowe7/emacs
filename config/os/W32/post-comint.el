(put 'post-comint 'rcsid
 "$Id: post-comint.el,v 1.3 2004-07-21 20:18:21 cvs Exp $")

(chain-parent-file t)

(defun processes ()
  (let ((l1 (split (eval-process "/bin/ps") "
")))
    (loop for x in (cdr l1)
	  collect 
	  (let ((l (split x "[ 	]+")))
	    (nconc (list 
		    (car (read-from-string (elt l 1)))
		    (car (read-from-string (elt l 2)))
		    (car (read-from-string (elt l 3)))
		    (car (read-from-string (elt l 4)))
		    (car (read-from-string (elt l 5)))
		    (car (read-from-string (elt l 6))))
		   (nthcdr 6 l))
	    )
	  )
    )
  )
; (processes)


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

(add-hook 'shell-mode-hook '(lambda () (define-key shell-mode-map "" 'interrupt-subjob)))

(add-to-list 'comint-output-filter-functions 'comint-watch-for-password-prompt)