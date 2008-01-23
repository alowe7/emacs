(put 'keys 'rcsid
 "$Id: keys.el,v 1.1 2008-01-23 05:51:11 alowe Exp $")

(chain-parent-file t)
(autoload 'logview-hours "logview-mode")
(global-set-key [f10] 'logview-hours)

(require 'ctl-ret)
(define-key ctl-RET-map (vector (ctl ? )) 'grep-find)

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)

(require 'ctl-slash)
(define-key ctl-/-map "u" 'unbind)
