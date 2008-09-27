(put 'ctl-backslash 'rcsid
 "$Id: ctl-backslash.el,v 1.3 2008-09-27 16:34:01 keystone Exp $")

(if (not (fboundp 'ctl-\\-prefix)) 
    (define-prefix-command 'ctl-\\-prefix));; don't wipe out map if it already exists

(global-set-key "" 'ctl-\\-prefix)

(setq ctl-\\-map (symbol-function  'ctl-\\-prefix))


(provide 'ctl-backslash)
