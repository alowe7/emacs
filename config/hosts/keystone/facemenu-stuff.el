(require 'ctl-dot)

(define-key ctl-.-map "b" 'facemenu-set-bold)
(define-key ctl-.-map "i" 'facemenu-set-italic)
(define-key ctl-.-map "l" 'facemenu-set-bold-italic)
(define-key ctl-.-map "u" 'facemenu-set-underline)
(define-key ctl-.-map "o" 'facemenu-set-face)


(define-key ctl-.-map "f" '(lambda (beg end) (interactive "r") (facemenu-set-face 'fixed-pitch beg end)))


