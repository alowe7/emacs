(put 'keys 'rcsid
 "$Id: keys.el,v 1.1 2005-05-19 20:52:25 cvs Exp $")

(chain-parent-file t)

; whack flag-SPC as alternative alt-SPC

(global-set-key (vector 25165856) 'alt-SPC-prefix)
; (global-set-key (vector '\H-s-SPC) 'alt-SPC-prefix)

