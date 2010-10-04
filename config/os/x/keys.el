(put 'keys 'rcsid
 "$Id$")

(chain-parent-file t)

; whack flag-SPC as alternative alt-SPC

(global-set-key (vector 25165856) 'alt-SPC-prefix)
; (global-set-key (vector '\H-s-SPC) 'alt-SPC-prefix)

