(put 'keys 'rcsid
 "$Id: keys.el,v 1.4 2008-01-01 20:57:32 slate Exp $")

; machine specific key bindings.  needs factoring

(require 'ctl-ret)

(define-key ctl-RET-map (vector (ctl ? )) 'grep-find)

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)

; just use grep-find
; (define-key ctl-RET-map (vector ?\C- ) 'zz)

(global-set-key (vector 'f10) 'maximize-frame)
(global-set-key (vector 'C-f10) 'iconify-frame)

(global-set-key (vector ?) 'undo)
(global-set-key (vector ?\C-c ?\C-j) 'font-lock-fontify-buffer)

