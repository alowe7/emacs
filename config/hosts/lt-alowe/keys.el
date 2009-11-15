(put 'keys 'rcsid
 "$Id: keys.el,v 1.2 2009-11-15 02:12:23 alowe Exp $")

(chain-parent-file t)
(autoload 'logview-hours "logview-mode")
(global-set-key [f10] 'logview-hours)

(require 'ctl-ret)
(define-key ctl-RET-map (vector (ctl ? )) 'grep-find)

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)

(require 'ctl-slash)
(define-key ctl-/-map "u" 'unbind)

; C-S-a
(global-set-key (quote [33554433]) (quote soft-fill-paragraph))
