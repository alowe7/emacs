(put 'pre-w3m 'rcsid
 "$Id: pre-w3m.el,v 1.5 2006-03-01 02:52:43 tombstone Exp $")
(setq w3m-use-cookies t)
(setq w3m-home-page "about:")

(require 'compat)

(load-file "/usr/share/emacs/site-lisp/w3m-1.3.2/.autoloads")
(require 'w3m)
(load-library "post-w3m")

