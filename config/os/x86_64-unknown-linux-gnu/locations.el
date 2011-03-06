(put 'locations 'rcsid
 "$Id: locations.el 890 2010-10-04 03:34:24Z svn $")


; alternative locations for compatibility

; todo transmogrify with os/W32/locations.el

(defvar etc "/etc")
(defun hosts () (interactive)
  (find-file (concat etc "/hosts"))
  )

(provide 'locations)

