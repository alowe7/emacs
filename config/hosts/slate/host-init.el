(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/slate/host-init.el,v 1.10 2009-01-23 23:10:08 slate Exp $")

; enoch..tombstone..slate

(require 'post-dired)

(require 'ctl-slash)
(require 'ctl-ret)

(require 'long-comment)
(require 'whack-font)

(require 'cat-utils)
; (require 'gnuserv)
(setq display-time-day-and-date t)
(display-time)

(scroll-bar-mode -1)

(and (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(and (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(load-library "bookmark")
(load-library "post-bookmark")

(setq x-select-enable-clipboard t)

(setq grep-command "grep -n -i -e ")
(setq jit-lock-stealth-time 1)

(defvar default-font "-*-lucida-medium-r-normal-*-14-140-*-*-*-*-iso8859-1")

(defun lframe ()
  (interactive)
  (let* ((default-frame-alist default-frame-alist))

    (loop for x in 
	  '(
	    (width . 119)
	    (height . 29)
	    (top . 62)
	    (left . 32)
	    (font . default-font))
	  do (add-association x 'default-frame-alist t)
	  )
    (call-interactively 'switch-to-buffer-other-frame)
    )
  )

(require 'lazy-lock)

(post-wrap "dired")

; necessary when compile is preloaded, 
; (post-wrap "compile")

; uncompress isn't as obsolete as someone thinks.
(autoload 'uncompress-while-visiting "uncompress")

; append to load path to find sources 
(add-to-list 'load-path "/u/emacs-22.1/lisp/emacs-lisp/" t)
; (member  "/u/emacs-22.1/lisp/emacs-lisp/" load-path)

(require 'xz-loads)
(require 'post-view)

; disable stupid comint `field' properties
; (setq comint-use-prompt-regexp-instead-of-fields t)

(setq *sisdirs* '(("/root/slash/.p" "/root/.p") ("/root/slash" "")))

; string quoting logic in font-lock if f***-ed up

(setq font-lock-string-face 'default)

(add-to-load-path-p "/z/db" t)
(require 'zt-loads)

(add-to-list 'warning-suppress-types '(undo discard-info))
