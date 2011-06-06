(put 'locations 'rcsid
 "$Id$")


; alternative locations for compatibility

; todo transmogrify with os/W32/locations.el

(defvar etc "/etc")
(defun hosts () (interactive)
  (find-file (concat etc "/hosts"))
  )

(provide 'locations)

