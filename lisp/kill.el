(put 'kill 'rcsid
 "$Id: kill.el,v 1.1 2004-02-05 23:11:29 cvs Exp $")

(defun copy-cwd-as-kill (arg) 
  "apply `kill-new' to `default-directory' with optional ARG, canonify first"
  (interactive "P")
  (let ((s default-directory))
    (and arg (setq s (w32-canonify s)))
    (kill-new s)
    (message s))
  )

(global-set-key (vector ? ?\C-0) 'copy-cwd-as-kill)
