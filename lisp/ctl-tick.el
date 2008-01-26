(put 'ctl-tick 'rcsid
 "$Id: ctl-tick.el,v 1.1 2008-01-26 20:13:48 slate Exp $")

(unless (fboundp 'ctl-tick-prefix) 
    (define-prefix-command 'ctl-tick-prefix))

(unless (and (boundp 'ctl-tick-map) ctl-tick-map)
  (setq ctl-tick-map (symbol-function 'ctl-tick-prefix)))

(global-set-key (vector ?\C-') 'ctl-tick-prefix)

(provide 'ctl-tick)
