(put 'SunOS 'rcsid 
 "$Id: os-init.el,v 1.3 2003-05-20 01:07:05 cvs Exp $")

(message "SunOS")
(add-to-list 'load-path "~/x/elisp")

(defun shell-2 nil (interactive) (shell2 2))
(global-set-key "2" (quote shell-2))
(defun host-ok (arg) t)
