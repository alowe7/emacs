(put 'keys 'rcsid
 "$Id$")

; for telnet sessions

(chain-parent-file t)

(global-set-key (vector 'kp-f4) 'get-scratch-buffer)
(global-set-key (vector 'f4) 'get-scratch-buffer)

(global-set-key "\C-j " 'grep-find)

