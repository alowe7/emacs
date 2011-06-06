(put 'keys 'rcsid
 "$Id$")

(chain-parent-file t)

(require 'ctl-ret)

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)

(define-key ctl-RET-map (vector (ctl ? )) 'grep-find)

(define-key ctl-/-map "u" 'makeunbound)
(define-key ctl-/-map "\C-d" 'sisdir)

(define-key ctl-RET-map "" 'yank-like)
(define-key ctl-RET-map "\C-s" 'isearch-thing-at-point)

; not sure if this isn't just masking a bug
(define-key isearch-mode-map "\C-m" 'isearch-exit)
