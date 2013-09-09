(put 'pre-w3m 'rcsid
 "$Id: pre-w3m.el 1066 2012-07-27 15:56:52Z alowe $")

(setq w3m-use-cookies t)
(setq w3m-home-page "about:")

;; emacs-w3m-1.4.5/w3m.el defines some obsolete CYGWIN options in w3m-command-environment
(setq w3m-command-environment nil)

; (require 'w3m)
; lazy load post-w3m features
(add-hook 'w3m-load-hook (lambda () (load-library "post-w3m")))

