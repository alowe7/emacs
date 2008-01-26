(put 'keys 'rcsid
 "$Id: keys.el,v 1.3 2008-01-26 20:13:48 slate Exp $")

(chain-parent-file t)

(global-set-key "\M-_"  'undo)

(require 'ctl-slash)
(define-key ctl-/-map "f" 'locate)

(require 'nautilus)
(global-set-key (vector 'f12) 'nautilus)
