(put 'Emacs21 'rcsid
 "$Id: Emacs21.el,v 1.5 2003-12-09 22:37:04 cvs Exp $")

(define-key help-map "a" 'apropos)

; got used to using space for completion...
(define-key minibuffer-local-completion-map " " 'minibuffer-complete)
(define-key minibuffer-local-completion-map "	" 'minibuffer-complete-word)

(set-face-attribute 'default nil :family "verdana" :height 100 :weight 'ultra-light)
; (face-attribute 'default :family)

; silence the dinger
(setq ring-bell-function '(lambda () nil))

