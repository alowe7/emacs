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
 sisdirs-default-file
 (expand-file-name ".sisdirs" (file-name-directory (locate-config-file "host-init")))
 )

(setq Info-default-directory-list
      `(
	"/usr/share/info/"
	,(canonify (expand-file-name "info"  (getenv "EMACS_DIR")) 0)
	"/usr/local/share/info/")
      )

; its a lie.  permit special frame handling
(autoload 'calendar "mycal")

;; 
;; bad ideas?
;; 

(setq temporary-file-directory "/tmp")

; string quoting logic in font-lock if f***-ed up
; (setq font-lock-string-face 'default)

; (setq *advise-help-mode-finish* t)

; struggling with daylight savings time again
(set-time-zone-rule "CST6CDT")

(setq sgml-default-doctype-name  "-//W3C//DTD XHTML 1.0 Transitional//EN")
(setq sgml-catalog-files '("/a/lib/DTD/catalog"))

;; hooks

(remove-hook 'kill-buffer-query-functions 'process-kill-buffer-query-function)

; this shortens the timeout for \\localdir\file being interpreted as \\host\file
; (mount-hook-file-commands)

; xxx mongrify
(add-hook 'locate-mode-hook 'fb-mode)

;; other requires

(setq *gnuserv-dired-files* t)
(require 'gnuserv)

; why load when you can require?
(require 'xz-loads)

(require 'myblog)

;;
;; actions
;;

; force post-load hooks now... 
; tbd figure out why this is necessary
(post-after-load "locate")
; (post-after-load "comint")

(display-time)

