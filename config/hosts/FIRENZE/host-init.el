(put 'host-init 'rcsid 
 "$Id: host-init.el 1080 2012-09-16 19:55:25Z alowe $")

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


;(load "whack-post-init" t t)
(let* ((default-directory "/src/emacs/config/common")
	 (l (directory-files "." nil "post-.*\\.el$")))
    (dolist (x l)
	    (unless (file-directory-p x)
	      (apply 'eval-after-load
		     (let ((basename (file-name-sans-extension x)))
		       (list
			(intern (substring basename (progn (string-match "post-" x) (match-end 0))))
			`(load ,basename nil t))
		       )
		     )
	      )
	    )
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
; (set-time-zone-rule "CST6CDT")
(set-time-zone-rule "EST6EDT")

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

(defmacro requirep (feature) `(condition-case err (require ,feature) (file-error nil)))
(requirep 'xz-loads)

(require 'comint-keys)

; really only want this 
(add-hook 'dired-load-hook (lambda () 
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

(setq path-separator ":")

(requirep 'w3m-loads)

(requirep 'zt-loads)

(requirep 'tw)

; TBD lazy load hairy python setups... 
(require 'ctl-ret)
; its a lie, but the second time, will be true...
(define-key ctl-RET-map "" (lambda () (interactive) (require 'py-loads)))

(autoload 'w3m-goto-url "w3m")
(define-key ctl-RET-map "g" (lambda () (interactive) (let ((url (thing-at-point 'url))) (if url (w3m-goto-url url) (message "thing-at-point doesn't appear to be a url")))))


(require 'auto-modes)


(setq *key-program*  "/home/alowe/bin/key.exe")
(setq *sword-file* "/src/.private/swords"
      *default-swordfile* *sword-file* )

(scan-file-p "/src/.private/.xdbrc")
(setq *dired-path* '("/work/inscom" "/work" "/src"))

;; for now...
;; (setenv "PATH" "c:\\Program Files\\Common Files\\Microsoft Shared\\Windows Live;c:\\Program Files (x86)\\Common Files\\Microsoft Shared\\Windows Live;c:\\home\\alowe\\config\\os\\W32\\bin;c:\\home\\alowe\\bin;c:\\Perl\\site\\bin;c:\\Perl\\bin;c:\\usr\\local\\bin;c:\\usr\\bin;c:\\usr\\bin;c:\\usr\\local\\lib\\emacs-24.1\\bin;c:\\Windows\\system32;c:\\Windows;c:\\Windows\\System32\\Wbem;c:\\Windows\\System32\\WindowsPowerShell\\v1.0;c:\\Program Files\\CREDANT\\Shield v6.7;c:\\Program Files (x86)\\Windows Live\\Shared;c:\\Program Files\\TortoiseSVN\\bin")

(require 'xdb)

(require 'cygwin)
(add-hook 'find-file-not-found-functions 'cygwin-file-not-found)
