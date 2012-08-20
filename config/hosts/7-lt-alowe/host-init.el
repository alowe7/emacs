(put 'host-init 'rcsid 
 "$Id$")

; for visual preferences, prefer X resources, Windows registry, or command line options, in that order.
; see:
;  (info "(emacs) Table of Resources")
;  (info "(emacs) MS-Windows Registry")
; also see ~/emacs/config/os/W32/emacs.reg

; there do not appear to be resources for the following
(set-default 'cursor-type '(bar . 2))
(set-default 'cursor-in-non-selected-windows nil)
(setq resize-mini-windows nil)

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


(load "whack-post-init" t t)

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

; useless garbage
(when (featurep 'tramp)
  (tramp-unload-tramp)
  )

(defvar *deprecated-file-name-handlers* '(ange-ftp-hook-function  ange-ftp-completion-hook-function))

(setq file-name-handler-alist
      (loop for handler in
	    file-name-handler-alist
	    unless (member (cdr handler) *deprecated-file-name-handlers*)
	    collect handler)
      )

(/*
  ; --- this whole thing is a waste of time ---

  ; this should  have the side effect of defining some environment vars
 (scan-file-p "~/.bashrc")
 (scan-file-p (expand-file-name ".bashrc" (host-config)))

  ; however, setting PATH to unix-style breaks call-process, etc.
 (setenv "PATH" (w32-canonify-path (getenv "PATH") "c:"))
 */)

(require 'w3m-loads)

(require 'zt-loads)
(require 'tw)

; hairy python setups

(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(autoload 'python-mode "python-mode" "Python editing mode." t)
(autoload 'py-shell "python-mode" "Python editing mode." t)
; (setq py-shell-name "/Python27/pythonw")
(setq py-shell-name "/Python27/python")

(require 'ctl-backslash)
(define-key ctl-\\-map "" 'py-shell)

; (add-to-list 'load-path "~/.emacs.d/vendor/pymacs-0.24-beta2")
; (add-to-list 'load-path "~/.emacs.d/vendor/auto-complete-1.2")

(setenv "PYMACS_PYTHON"  py-shell-name)
(require 'pymacs)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)

(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-dictionary-directories "/usr/share/emacs/site-lisp/auto-complete-1.2/dict")

(define-key ctl-RET-map "g" (lambda () (interactive) (let ((url (thing-at-point 'url))) (if url (w3m-goto-url url) (message "thing-at-point doesn't appear to be a url")))))

(add-to-list 'find-function-source-path "/u/python-mode.el-6.0.3")
