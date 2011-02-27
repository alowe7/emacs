(require 'ctl-slash)
(require 'ctl-ret)

(define-key ctl-/-map "u" 'makeunbound)

(define-key ctl-RET-map "" 'yank-like)

(define-key ctl-RET-map "\C-s" 'isearch-thing-at-point)