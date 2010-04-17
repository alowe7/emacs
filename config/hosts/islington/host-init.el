(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/islington/host-init.el,v 1.5 2010-04-17 18:53:08 alowe Exp $")

; enoch..tombstone..slate..islington

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

; (defvar default-font "-*-lucida-medium-r-normal-*-14-140-*-*-*-*-iso8859-1")
(defvar default-font "-adobe-new century schoolbook-medium-r-normal--16-154-75-75-p-0-iso8859-2")

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


; necessary for preloaded libs 
; (post-wrap "dired")
; (post-wrap "compile")

; uncompress isn't as obsolete as someone thinks.
(autoload 'uncompress-while-visiting "uncompress")

; append to load path to find sources 
(add-to-list 'load-path "/u/emacs-23.1/lisp")

(require 'xz-loads)
(require 'post-view)

; disable stupid comint `field' properties
; (setq comint-use-prompt-regexp-instead-of-fields t)

(setq *sisdirs* '(("/root/slash/.p" "/root/.p") ("/root/slash" "")))

; string quoting logic in font-lock is f***-ed up
(setq font-lock-string-face 'default)

; should be found in /usr/share/emacs/site-lisp/zt-1.0
;(add-to-load-path-p "/z/db" t)
(require 'zt-loads)

(defvar warning-suppress-types nil)
(add-to-list 'warning-suppress-types '(undo discard-info))

(setq user-mail-address "l7@alowe.com")

; mail-default-directory

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(display-time-mode t))

