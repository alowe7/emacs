(put 'custom 'rcsid
 "$Id: custom.el,v 1.1 2006-01-31 01:39:41 tombstone Exp $")

; random convenience functions for tombstone

(defun virtual-users () (interactive)
  (let ((b (zap-buffer "*virtual users*")))
    (call-process *perl-command* "/etc/mail/virtusertable"
		  b
		  nil
		  "-n"
		  "-e"
		  "unless (/nouser/) {split;print $_[0],'\n'}"
		  )
    (pop-to-buffer b)
    (sort-lines nil (point-min) (point-max))
    (beginning-of-buffer)
    (view-mode)
    )
  )

; no reason
(setenv "MANWIDTH" "132")
