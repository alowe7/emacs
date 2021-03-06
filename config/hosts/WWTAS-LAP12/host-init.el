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

(defmacro requirep (feature) `(condition-case err (require ,feature) (file-error nil)))

(requirep 'xz-loads)

(require 'comint-keys)

; use ls-lisp on this host.  or dired on drives other than $SYSTEMDRIVE acts weird.
; (setq ls-lisp-use-insert-directory-program t)
(setq ls-lisp-use-insert-directory-program nil)

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

(setq path-separator ":")

(when (requirep 'zt-loads)
  (setq *zt-db-driver* (set-zt-db-driver "mongo"))
  (require (intern (concat "zt-" *zt-db-driver*)))
  )

(requirep 'tw)


(require 'auto-modes)


(setq *key-program*  "/home/alowe/bin/key.exe")
(setq *sword-file* "/src/.private/swords"
      *default-swordfile* *sword-file* )

(require 'sh)

; (require 'cygwin)
; (add-hook 'find-file-not-found-functions 'cygwin-file-not-found)

(setq write-region-inhibit-fsync t)

;   browse-url-w3 will (require 'w3), so make sure it is on your load path.  
(setq browse-url-browser-function 'browse-url-w3)
; (add-to-list 'find-file-not-found-functions  '(lambda () (browse-url buffer-file-name)))

(require 'server)
(unless (eq (server-running-p "server") t) (server-start) )

(let ((extra-projects '("/z/w")))
  (loop for x in extra-projects do
	(let* (
	       (load-directory (expand-file-name ".emacs.d" x))
	       (files (get-directory-files load-directory t ".el$")))
	  (loop for y in files do
		(let ((basename (file-name-sans-extension y)))
  ; this is so if happens to be a compiled version in there, load that instead of the source
		  (load basename t t)
		  )
		)
	  )
	)
  )
