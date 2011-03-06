(put 'keys 'rcsid
 "$Id: keys.el 890 2010-10-04 03:34:24Z svn $")

(chain-parent-file t)

(global-set-key "\M-_"  'undo)

(require 'ctl-slash)
(define-key ctl-/-map "f" 'locate)

(require 'nautilus)
(global-set-key (vector 'f12) 'nautilus)
