(defconst rcs-id "$Id: urprefix.el,v 1.3 2000-07-30 21:07:48 andy Exp $")
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