(put 'post-buffers 'rcsid
 "$Id$")

; (require 'buffer-util)
(require  'ctl-backslash)

(define-key ctl-\\-map "\C-t" 'roll-buffer-list)
(define-key ctl-\\-map "\C-l" 'roll-buffer-like)
(define-key ctl-\\-map "\C-e" 'roll-buffer-with-like)
(define-key  ctl-\\-map "\C-w" 'roll-buffer-with)
(define-key  ctl-\\-map "\C-m" 'roll-buffer-with-mode)

(define-key ctl-\\-map "l" 'list-buffers-like)
(define-key ctl-\\-map "w" 'list-buffers-with)
(define-key ctl-\\-map "i" 'list-buffers-in)
(define-key ctl-\\-map "m" 'list-buffers-mode)

(define-key ctl-\\-map "~" 'kill-buffers-not-modified)
(define-key ctl-\\-map "!" 'kill-buffers-mode)