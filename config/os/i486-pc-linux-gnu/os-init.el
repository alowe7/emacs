(put 'os-init 'rcsid
 "$Id$")

(and (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(and (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(and (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(and (fboundp 'blink-cursor-mode) (blink-cursor-mode -1))

; use external program for dired
(setq ls-lisp-use-insert-directory-program t)
(setq dired-listing-switches "-lt")
(setq dired-use-ls-dired t)

; (require 'ls-lisp)
; (setq ls-lisp-use-insert-directory-program nil)
; (setq ls-lisp-verbosity nil)
