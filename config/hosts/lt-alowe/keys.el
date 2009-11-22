(put 'keys 'rcsid
 "$Id: keys.el,v 1.3 2009-11-22 22:50:34 alowe Exp $")

(chain-parent-file t)
(autoload 'logview-hours "logview-mode")
(global-set-key [f10] 'logview-hours)

(require 'ctl-ret)
(define-key ctl-RET-map (vector (ctl ? )) 'grep-find)

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)

(require 'ctl-slash)
(define-key ctl-/-map "u" 'unbind)

; (kbd "C-S-a") = (quote [33554433])
(global-set-key (kbd "C-S-a") (quote soft-fill-paragraph))

(global-set-key (kbd "C-x C-.") 'point-to-register)
(global-set-key (kbd "C-x C-,") 'jump-to-register)

