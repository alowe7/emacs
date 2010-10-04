(put 'modes 'rcsid
 "$Id$")

(defun get-parent-modes (mode)
  "given derived mode MODE, return a list of all parent modes
"
  (loop
   with ancestors = nil
   with parent = nil
   do (push mode ancestors)
   while (setq mode (get mode 'derived-mode-parent))
   finally return ancestors
   )
  )
; (get-parent-modes 'cmd-mode)
; (member 'shell-mode (get-parent-modes 'cmd-mode))



(provide 'modes)
