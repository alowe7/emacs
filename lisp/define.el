(put 'define 'rcsid 
 "$Id: define.el,v 1.5 2000-10-03 16:50:27 cvs Exp $")
(defun define (term) (interactive "sterm: ")
  (perl-command "define" term)
  (pop-to-buffer " *perl*")
  (rename-buffer (format "*define %s" term))
  (beginning-of-buffer)
  )