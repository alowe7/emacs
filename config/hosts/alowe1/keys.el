(put 'keys 'rcsid
 "$Id: keys.el,v 1.1 2004-09-10 15:21:43 cvs Exp $")

(chain-parent-file t)

(require 'ctl-slash)


(define-key ctl-/-map "\C-l" 'xl)

; define ctl-/ ctl-/ as another map

(if (not (fboundp 'ctl-/-ctl-/-prefix)) 
    (define-prefix-command 'ctl-/-ctl-/-prefix)) ;; don't wipe out map if it already exists

(define-key ctl-/-map (vector (ctl ?/)) 'ctl-/-ctl-/-prefix)

(setq ctl-/-ctl-/-map (symbol-function  'ctl-/-ctl-/-prefix))

(define-key ctl-/-ctl-/-map "\C-l" 'xll)