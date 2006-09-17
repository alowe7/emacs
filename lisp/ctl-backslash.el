(put 'ctl-backslash 'rcsid
 "$Id: ctl-backslash.el,v 1.1 2006-09-17 21:46:51 tombstone Exp $")

(if (not (fboundp 'ctl-\-prefix)) 
    (define-prefix-command 'ctl-\-prefix));; don't wipe out map if it already exists

(global-set-key "" 'ctl-\-prefix)

(setq ctl-\-map (symbol-function  'ctl-\-prefix))

