(put 'SunOS 'rcsid 
 "$Id: os-init.el,v 1.5 2004-02-27 16:55:17 cvs Exp $")

(add-to-load-path "~/x/elisp")

(defun host-ok (arg) t)

(setq comint-prompt-regexp "^[0-9]+% *")
(set-default-font "-*-*-Medium-R-normal-sans-18-*-*-*-m-*-*-*")