(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe2/host-init.el,v 1.7 2001-07-27 14:19:22 cvs Exp $")

;(default-font "lucida console" nil 22)

;(set-frame-size (selected-frame) 72 30)
;(set-frame-position (selected-frame) 10 10)

(setq default-frame-alist
      '((top + -4)
	(left + -4)
	(width . 72)
	(height . 30)
	(background-mode . light)
	(cursor-type . box)
	(border-color . "black")
	(cursor-color . "black")
	(mouse-color . "black")
	(background-color . "white")
	(foreground-color . "black")
	(vertical-scroll-bars)
	(internal-border-width . 0)
	(border-width . 2)
	(font . "-*-lucida console-normal-r-*-*-22-nil-*-*-*-*-*-*-")
	(menu-bar-lines . 0))
      )

(setq initial-frame-alist default-frame-alist)

(if (file-directory-p "d:/x/elisp")
    (load-file  "d:/x/elisp/.autoloads")
  )

(require 'xz-loads)
(require 'gnuserv)

(lastworld)
