(put 'pre-w3m 'rcsid
 "$Id$")

(setq w3m-use-cookies t)
(setq w3m-home-page "about:")

(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m "w3m"  "invoke w3m web browser" t)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)

(global-set-key "\C-xw" 'w3m)
(global-set-key "\C-xm" 'browse-url-at-point)

;; emacs-w3m-1.4.5/w3m.el defines some obsolete CYGWIN options in w3m-command-environment
(setq w3m-command-environment nil)

; (require 'w3m)
; lazy load post-w3m features
(add-hook 'w3m-load-hook '(lambda () (load-library "post-w3m")))

