(put 'keys 'rcsid
 "$Id: keys.el,v 1.4 2007-07-30 23:56:45 tombstone Exp $")

; for telnet sessions

(chain-parent-file t)

(global-set-key (vector 'kp-f4) 'get-scratch-buffer)
(global-set-key (vector 'f4) 'get-scratch-buffer)

(global-set-key "\C-j " 'grep-find)

