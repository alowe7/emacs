(put 'urprefix 'rcsid "$Id: urprefix.el,v 1.4 2000-10-03 16:44:08 cvs Exp $")
(provide 'urprefix)

(if (not (fboundp 'ctl-_-prefix)) 
    (define-prefix-command 'ctl-_-prefix))

(global-set-key (vector ?\C-_) 'ctl-_-prefix)



(if (not (fboundp 'ctl-equal-prefix)) 
    (define-prefix-command 'ctl-equal-prefix))

(global-set-key (vector ?\C-=) 'ctl-equal-prefix)


(if (not (fboundp 'ctl-dash-prefix)) 
    (define-prefix-command 'ctl-dash-prefix))

(global-set-key (vector ?\C--) 'ctl-dash-prefix)