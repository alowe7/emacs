(put 'host-init 'rcsid
     "$Id$")

; for visual preferences, prefer X resources, Windows registry, or command line options, in that order.
; see:
;  (info "(emacs) Table of Resources")
;  (info "(emacs) MS-Windows Registry")
; also see ~/emacs/config/os/W32/emacs.reg

; there do not appear to be resources for the following
(setq
 cursor-type (quote (bar . 1))
 cursor-in-non-selected-windows nil
 resize-mini-windows nil
)

(setq 
 bookmark-default-file
 (expand-file-name ".emacs.bmk" (file-name-directory (locate-config-file "host-init")))
)

(setq Info-default-directory-list
      `(
	"/usr/share/info/"
	,(canonify (expand-file-name "info"  (getenv "EMACS_DIR")) 0)
	"/usr/local/share/info/")
      )

; its a lie.  permit special frame handling
(autoload 'calendar "mycal")

(setq sgml-default-doctype-name  "-//W3C//DTD XHTML 1.0 Transitional//EN")
(setq sgml-catalog-files '("/a/lib/DTD/catalog"))
; force post-load hooks now... 
; tbd figure out why this is necessary
(post-after-load "locate")

; lazy load comint helpers, but define the key bindings that invoke them
; (post-after-load "comint")
(require 'comint-keys)

(require 'xz-loads)
; tbd figure out why post-xz is not getting invoked
(add-hook 'xz-load-hook (lambda () (post-after-load "xz")))

(display-time)
