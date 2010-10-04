(put 'post-locate 'rcsid
 "$Id$")

(chain-parent-file t)

(defun select-locate-buffer () (interactive) (let ((l (collect-buffers-mode 'fb-mode)))(cond ((= (length l) 1) (switch-to-buffer (car l))) (roll-buffer-list l))))
