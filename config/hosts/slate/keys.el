(put 'keys 'rcsid
 "$Id: keys.el,v 1.6 2008-09-27 22:15:09 slate Exp $")

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

(require 'ctl-backslash)
(define-key ctl-\\-map "u" 'unbind)

(require 'ctl-slash)
(define-key ctl-/-map "" 'sisdir)

