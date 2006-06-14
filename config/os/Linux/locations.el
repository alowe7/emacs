(put 'locations 'rcsid
 "$Id: locations.el,v 1.1 2006-06-14 00:41:57 tombstone Exp $")


; alternative locations for compatibility

; todo transmogrify with os/W32/locations.el

(defvar etc "/etc")
(defun hosts () (interactive)
  (find-file (concat etc "/hosts"))
  )

(provide 'locations)

