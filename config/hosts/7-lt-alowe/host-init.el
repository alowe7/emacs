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
; resize-mini-windows nil
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

(setq temporary-file-directory (expand-file-name "/tmp"))

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

(require 'xz-loads)

(require 'comint-keys)

; really only want this 
(add-hook 'dired-load-hook '(lambda () 
			      (define-key dired-mode-map "e" 'dired-decrypt-find-file)
			      ))

(display-time)

(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(autoload 'python-mode "python-mode" "Python editing mode." t)
(autoload 'py-shell "python-mode" "Python editing mode." t)
; (setq py-shell-name "/Python27/pythonw")
(setq py-shell-name "/Python27/python")

(require 'ctl-backslash)
(define-key ctl-\\-map "" 'py-shell)

(defvar *whack* nil)
(setq *whack* t)
(when *whack*
  ; workaround post-load hook bug when module is autoloaded
  (require 'whack-post-init)
  )

; useless garbage
(when (featurep 'tramp)
  (tramp-unload-tramp)
  )

(loop for handler in '(ange-ftp-hook-function  ange-ftp-completion-hook-function)
      do
      (setq file-name-handler-alist (delete* handler file-name-handler-alist :test '(lambda (x y) (eq x (cdr y)))))
      )

(/*
  ; --- this whole thing is a waste of time ---

  ; this should  have the side effect of defining some environment vars
 (scan-file-p "~/.bashrc")
 (scan-file-p (expand-file-name ".bashrc" (host-config)))

  ; however, setting PATH to unix-style breaks call-process, etc.
 (setenv "PATH" (w32-canonify-path (getenv "PATH") "c:"))
 */)

; (find-file-in-path "pre-w3m.el")

(require 'zt-loads)

