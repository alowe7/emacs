(put 'pre-w3m 'rcsid
 "$Id: pre-w3m.el,v 1.6 2006-03-09 15:00:34 alowe Exp $")
(setq w3m-use-cookies t)
(setq w3m-home-page "about:")

(provide 'w3m-compat)

; (load-file "/usr/share/emacs/site-lisp/w3m-1.3.2/.autoloads")
(require 'w3m)
(load-library "post-w3m")

