(put 'post-locate 'rcsid
 "$Id: post-locate.el,v 1.1 2009-11-28 20:09:54 alowe Exp $")

(chain-parent-file t)

(defun select-locate-buffer () (interactive) (let ((l (collect-buffers-mode 'fb-mode)))(cond ((= (length l) 1) (switch-to-buffer (car l))) (roll-buffer-list l))))
