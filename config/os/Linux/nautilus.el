(put 'nautilus 'rcsid
 "$Id: nautilus.el,v 1.1 2007-04-08 22:46:43 tombstone Exp $")

(defun nautilus ()
  (interactive)
  (call-process "/usr/bin/nautilus" nil nil nil default-directory)
  )
(global-set-key (vector 'f12) 'nautilus)

