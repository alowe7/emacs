(put 'keys 'rcsid
 "$Id: keys.el,v 1.2 2010-10-02 21:53:57 alowe Exp $")

(chain-parent-file t)
(require 'ctl-ret)

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)

(define-key ctl-RET-map (vector (ctl ? )) 'grep-find)

(define-key ctl-/-map "u" 'makeunbound)
(define-key ctl-RET-map "" 'yank-like)
(define-key ctl-RET-map "\C-s" 'isearch-thing-at-point)

; not sure if this isn't just masking a bug
(define-key isearch-mode-map "\C-m" 'isearch-exit)
