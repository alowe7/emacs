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

(setq path-separator ":")

(requirep 'w3m-loads)

(requirep 'zt-loads)

(requirep 'tw)

(autoload 'w3m-goto-url "w3m")
(define-key ctl-RET-map "g" (lambda () (interactive) (let ((url (thing-at-point 'url))) (if url (w3m-goto-url url) (message "thing-at-point doesn't appear to be a url")))))


(require 'auto-modes)


(setq *key-program*  "/home/alowe/bin/key.exe")
(setq *sword-file* "/src/.private/swords"
      *default-swordfile* *sword-file* )

(scan-file-p "/psi/.private/.xdbrc")
(setq *txdb-options* (nconc (and (getenv "XDB") (list "-b" (getenv "XDB"))) (and (getenv "XDBHOST") (list "-h" (getenv "XDBHOST")))))
(setq *dired-path* '("/work" "/src" "/phi" "/psi" "/chi"))

(require 'xdb)

; (require 'cygwin)
; (add-hook 'find-file-not-found-functions 'cygwin-file-not-found)

(defun pyflake ()
  (interactive)

  ; TBD lazy load hairy python setups... 

  ; set magic unbuffered flag needed for pdb to work as subprocess
  ; (setq gud-pdb-command-name "python -u -mpdb")
  (setenv "PYTHONUNBUFFERED" "true")
  (setq gud-pdb-command-name "python -mpdb")

  ; put this here, since python-mode is not always be available
  ; see auto-modes.el

  ; also see py-loads.el
  (autoload 'python-mode "python")

  ; this is for files that begin with shebang
  (add-to-list 'guess-auto-mode-alist
	       '("python" . python-mode)
	       )
  ; this is for files with a .py extension
  (add-auto-mode "\\.py$" 'python-mode)

  (add-to-list 'interpreter-mode-alist '("python" . python-mode))

  ; (autoload 'py-shell "python-mode" "Start an interactive Python interpreter in another window." t)
  ; (define-key ctl-RET-map  "\C-y" 'py-shell)

  (when (and
	 (not (boundp 'epy-install-dir))
	 (file-directory-p "/u/emacs-for-python"))
  ;    (add-to-list 'load-path (expand-file-name "/u/emacs-for-python"))
    (load-file "/u/emacs-for-python/epy-init.el")
  ; pretty sure epy is not using abbrevs tables correctly.
  ; anyway, for now... 
    (setq abbrevs-changed nil)
    )

  ; undo some weird things epy does

  ; default is nil, epy-completion turns it on.  turn it back off.
  (setq skeleton-pair nil)

  ; undo some weird keymappings
  (when (boundp 'ido-common-completion-map)
    (let ((map ido-common-completion-map))
      (define-key map "\C-j" 'ido-select-text)
      (define-key map "\C-m" 'ido-exit-minibuffer)
      (define-key map "\C-a" 'ido-toggle-ignore)
      )
    )

  (require 'pydoc)

  (require 'flymake)

  ; default behavior of flymake is to silently fail
  (setq flymake-log-level 4)

  (defun flymake-pylint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "epylint" (list local-file))))

  ; something along the lines of guess-auto-mode for shebang files
  (defadvice flymake-get-init-function (around 
					hook-flymake-get-init-function
					first activate)
    ""

    ad-do-it

    (let ((filename (ad-get-arg 0))
	  (return-value ad-return-value))

      (unless ad-return-value
	(cond
	 ((eq major-mode 'perl-mode)
	  (setq ad-return-value 'flymake-perl-init))
	 ((eq major-mode 'python-mode) 
	  (setq ad-return-value 'flymake-pylint-init))
	 )
	)
      )
    )

  ; (if (ad-is-advised 'flymake-get-init-function) (ad-unadvise 'flymake-get-init-function))

  (add-hook 'python-mode-hook
	    (lambda ()
	      (setq indent-tabs-mode nil)
	      (setq tab-width 4)
	      (setq python-indent 4)))
  ; (pop python-mode-hook)

  (setq save-abbrevs 'silently)
  )

(define-key ctl-RET-map  "\C-p" 'pyflake)

(setq write-region-inhibit-fsync t)

(ignore-errors
  (server-start)
  )