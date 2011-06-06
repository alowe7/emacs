(put 'keys 'rcsid
 "$Id$")

(chain-parent-file t)

(global-set-key "\M-_"  'undo)

(require 'ctl-slash)
(define-key ctl-/-map "f" 'locate)

(require 'nautilus)
(global-set-key (vector 'f12) 'nautilus)
