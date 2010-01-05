(put 'remote-host-init 'rcsid
 "$Id: remote-host-init.el,v 1.3 2010-01-05 05:28:26 slate Exp $")

; (read-string (format "u r in %s" "/home/a/emacs/config/os/x/remote-hosts/keystone/remote-host-init.el"))

; forgot why I did this...?
; maybe this was why:

;; Disable Scoll Lock warnings
;;(global-set-key [scroll-lock] 'noop)
;;(global-set-key [scroll-lock] nil)
;;(global-set-key [scroll-lock] '(quote nil))
(global-set-key (kbd "<Scroll_Lock>") '(lambda () (interactive) nil))
