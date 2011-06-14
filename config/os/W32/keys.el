(put 'keys 'rcsid
 "$Id$")

(chain-parent-file t)

(global-set-key "]" 'font+1)
(global-set-key "[" 'font-1)

;; (global-set-key "\C-:" (quote indent-for-comment))
(global-set-key (vector 'C-backspace) 'iconify-frame)

(global-set-key "" 'unix-canonify-region)
(global-set-key "" 'w32-canonify-region)
