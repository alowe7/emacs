(put 'Emacs21 'rcsid
 "$Id: Emacs21.el,v 1.4 2003-12-09 17:23:18 cvs Exp $")

(define-key help-map "a" 'apropos)

; got used to using space for completion...
(define-key minibuffer-local-completion-map " " 'minibuffer-complete)
(define-key minibuffer-local-completion-map "	" 'minibuffer-complete-word)

(set-face-attribute 'default nil :family "verdana" :height 104 :weight 'ultra-light)

; silence the dinger
(setq ring-bell-function '(lambda () nil))

