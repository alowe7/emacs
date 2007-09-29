(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/slate/host-init.el,v 1.1 2007-09-29 20:57:12 b Exp $")

; enoch..tombstone

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


(global-set-key (vector ?) 'undo)
(global-set-key (vector ?\C-c ?\C-j) 'font-lock-fontify-buffer)

(setq grep-command "grep -n -i -e ")
(setq jit-lock-stealth-time 1)
