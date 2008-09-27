(put 'emacs-wiki-load 'rcsid
 "$Id: emacs-wiki-load.el,v 1.3 2008-09-27 21:49:35 keystone Exp $")

;???
(add-to-list 'load-path "/usr/share/emacs/site-lisp/emacs-wiki")
(setq emacs-wiki-directories '("/z/wiki/Wiki/"))
(require 'emacs-wiki)

; (emacs-wiki-index)

(require 'ctl-backslash)
(define-key ctl-\\-map "w" 'emacs-wiki-index)
(defun maybe-emacs-wiki-follow-name-at-point ()
  (interactive)
; whats all this about?
  (condition-case x
      (emacs-wiki-follow-name-at-point)
    (error (debug)))
  )

(define-key emacs-wiki-mode-map (vector 'RET) 'maybe-emacs-wiki-follow-name-at-point)

(provide 'emacs-wiki-load)
