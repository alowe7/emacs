(put 'SunOS 'rcsid 
 "$Id: os-init.el,v 1.4 2004-01-26 22:42:03 cvs Exp $")

(add-to-list 'load-path "~/x/elisp")

(defun host-ok (arg) t)

(setq comint-prompt-regexp "^[0-9]+% *")
(set-default-font "-*-*-Medium-R-normal-sans-18-*-*-*-m-*-*-*")