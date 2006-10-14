(put 'ctl-backslash 'rcsid
 "$Id: ctl-backslash.el,v 1.2 2006-10-14 21:44:07 tombstone Exp $")

(if (not (fboundp 'ctl-\-prefix)) 
    (define-prefix-command 'ctl-\-prefix));; don't wipe out map if it already exists

(global-set-key "" 'ctl-\-prefix)

(setq ctl-\-map (symbol-function  'ctl-\-prefix))


(provide 'ctl-backslash)
