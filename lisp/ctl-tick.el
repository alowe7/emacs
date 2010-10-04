(put 'ctl-tick 'rcsid
 "$Id$")

(unless (fboundp 'ctl-tick-prefix) 
    (define-prefix-command 'ctl-tick-prefix))

(unless (and (boundp 'ctl-tick-map) ctl-tick-map)
  (setq ctl-tick-map (symbol-function 'ctl-tick-prefix)))

(global-set-key (vector ?\C-') 'ctl-tick-prefix)

(provide 'ctl-tick)
