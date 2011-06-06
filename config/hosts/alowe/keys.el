(put 'keys 'rcsid
 "$Id$")

(chain-parent-file t)
(autoload 'logview-hours "logview-mode")
(global-set-key [f10] 'logview-hours)

(require 'ctl-ret)
(define-key ctl-RET-map (vector (ctl ? )) 'grep-find)

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)

(require 'ctl-slash)
(define-key ctl-/-map "u" 'unbind)
