(defconst rcs-id "$Id: post-log.el,v 1.2 2000-07-30 21:07:47 andy Exp $")
(add-hook 'explore-hooks '(lambda () (log-entry "exploring %s" f)))
