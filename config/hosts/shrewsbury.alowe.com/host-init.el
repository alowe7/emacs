(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/islington/host-init.el,v 1.7 2010-10-04 01:56:10 slate Exp $")

; enoch..tombstone..slate..islington..shrewsbury

(require 'ctl-slash)
(require 'ctl-ret)

(and (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(and (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(and (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(and (fboundp 'blink-cursor-mode) (blink-cursor-mode -1))

(require 'long-comment)
(require 'whack-font)

(require 'cat-utils)
; (require 'gnuserv)
(setq display-time-day-and-date t)
(display-time)

(setq x-select-enable-clipboard t)

(setq grep-command "grep -n -i -e ")

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


; uncompress isn't as obsolete as someone thinks.
(autoload 'uncompress-while-visiting "uncompress")

; append to load path to find sources 
(add-to-list 'find-function-source-path "/u/emacs-23.1/lisp")

(require 'xz-loads)
(require 'post-view)

; disable stupid comint `field' properties
; (setq comint-use-prompt-regexp-instead-of-fields t)

(setq *sisdirs* '(("/root/slash/.p" "/root/.p") ("/root/slash" "")))

; string quoting logic in font-lock is f***-ed up
(setq font-lock-string-face 'default)

(defvar warning-suppress-types nil)
(add-to-list 'warning-suppress-types '(undo discard-info))

(setq user-mail-address "l7@alowe.com")

; mail-default-directory

(setq
 cursor-type (quote (bar . 1))
 cursor-in-non-selected-windows nil
 resize-mini-windows nil
)


(setq 
 bookmark-default-file
 (expand-file-name ".emacs.bmk" (file-name-directory (locate-config-file "host-init")))
 )

(post-after-load "locate")
(post-after-load "comint")
