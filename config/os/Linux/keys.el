(put 'keys 'rcsid
 "$Id: keys.el,v 1.2 2006-05-19 14:40:29 tombstone Exp $")

(chain-parent-file t)

(global-set-key "\M-_"  'undo)

(require 'ctl-slash)
(define-key ctl-/-map "f" 'locate)
