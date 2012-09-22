(put 'post-locate 'rcsid
 "$Id: post-locate.el 1043 2012-02-22 16:25:27Z alowe $")

(chain-parent-file t)

(require 'roll)
(defun select-locate-buffer ()
  (interactive)
  (let
      ((l (collect-buffers-mode 'fb-mode)))
    (cond ((= (length l) 1) (switch-to-buffer (car l))) (roll-buffer-list l))
    )
  )

