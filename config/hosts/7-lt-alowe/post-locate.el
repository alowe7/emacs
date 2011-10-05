(put 'post-locate 'rcsid
 "$Id: post-locate.el 1017 2011-06-06 04:32:11Z alowe $")

(chain-parent-file t)

(require 'roll)
(defun select-locate-buffer ()
  (interactive)
  (let
      ((l (collect-buffers-mode 'fb-mode)))
    (cond ((= (length l) 1) (switch-to-buffer (car l))) (roll-buffer-list l))
    )
  )

