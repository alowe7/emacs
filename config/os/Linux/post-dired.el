(put 'post-dired 'rcsid
 "$Id: post-dired.el,v 1.1 2007-10-30 03:54:17 slate Exp $")

(chain-parent-file t)

(defun dired-copy-filename-as-kill (arg) 
  "apply `kill-new' to `dired-get-filename'"
  (interactive "P")
  (let* ((f (or (dired-get-filename nil t) default-directory)))
    (kill-new f)
    (if (interactive-p) (message f))
    )
  )
(define-key dired-mode-map "\C-cw" 'dired-copy-filename-as-kill)