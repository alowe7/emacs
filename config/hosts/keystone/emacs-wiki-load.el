;???
(add-to-list 'load-path "/usr/share/emacs/site-lisp/emacs-wiki")
(setq emacs-wiki-directories '("/z/wiki/Wiki/"))
(require 'emacs-wiki)

; (emacs-wiki-index)

(require 'ctl-slash)
(define-key ctl-/-map "w" 'emacs-wiki-index)

(provide 'emacs-wiki-load)
