(put 'define 'rcsid 
 "$Id: define.el,v 1.6 2002-09-19 22:45:53 cvs Exp $")
(defun define (term) (interactive "sterm: ")
  (perl-command "define" term)
  (pop-to-buffer " *perl*")
  (rename-buffer (format "*define %s" term) t)
  (beginning-of-buffer)
  (toggle-read-only t)
  (view-mode)
  )