(put 'emacs-wiki-load 'rcsid
 "$Id: emacs-wiki-load.el,v 1.2 2010-04-17 18:53:08 alowe Exp $")

;???
(add-to-list 'load-path "/usr/share/emacs/site-lisp/emacs-wiki")
(setq emacs-wiki-directories '("/z/wiki/Wiki/"))
(require 'emacs-wiki)

; (emacs-wiki-index)

(require 'ctl-slash)
(define-key ctl-/-map "w" 'emacs-wiki-index)

(defun maybe-emacs-wiki-follow-name-at-point ()
  (interactive)
; whats all this about?
  (condition-case x
      (emacs-wiki-follow-name-at-point)
    (error (debug)))
  )

(define-key emacs-wiki-mode-map "\r" 'maybe-emacs-wiki-follow-name-at-point)

(provide 'emacs-wiki-load)
