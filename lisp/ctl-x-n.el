; yet another prefix map

(if (not (fboundp 'ctl-x-3-prefix)) 
    (define-prefix-command 'ctl-x-3-prefix)) ;; don't wipe out map if it already exists

(define-key ctl-x-map "3" 'ctl-x-3-prefix)

(setq ctl-x-3-map (symbol-function  'ctl-x-3-prefix))

(provide 'ctl-x-n)

(define-key ctl-x-3-map "l" '(lambda () (interactive) (apply 'copy-region-as-kill (line-as-region) )))

