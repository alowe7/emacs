(put 'keys 'rcsid
 "$Id: keys.el,v 1.3 2007-07-30 23:52:08 tombstone Exp $")

(chain-parent-file t)

(global-set-key (vector 'kp-f4) 'get-scratch-buffer)
(global-set-key (vector 'f4) 'get-scratch-buffer)

(require 'ctl-ret)
(define-key ctl-RET-map (vector ? ) 'grep-find)
