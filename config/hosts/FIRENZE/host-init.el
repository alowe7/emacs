(put 'host-init 'rcsid 
 "$Id$")

(eval-when-compile
  (setq byte-compile-warnings '(not cl-functions free-vars unresolved)))

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
(setq *xz-squish* 0)

(require 'comint-keys)

; use ls-lisp on this host.  or dired on drives other than $SYSTEMDRIVE acts weird.
; (setq ls-lisp-use-insert-directory-program nil)

(setq ls-lisp-use-insert-directory-program t)
(setq dired-listing-switches "-AGl")
; (setq dired-listing-switches "-l -g -t --time-style='+%Y-%m-%d %H:%M:%S'" )

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

;  tbd use `lynx -dump`
; (autoload 'w3m-goto-url "w3m")
; (define-key ctl-RET-map "g" (lambda () (interactive) (let ((url (thing-at-point 'url))) (if url (w3m-goto-url url) (message "thing-at-point doesn't appear to be a url")))))

(require 'auto-modes)


(setq *key-program* (locate-file "key" exec-path '(".exe")))
(setq *sword-file* "/psi/.private/swords"
      *default-swordfile* *sword-file* )

(require 'sh)
(scan-file-p "/psi/.private/.xdbrc")
(setq *txdb-options* (nconc (and (getenv "XDB") (list "-b" (getenv "XDB"))) (and (getenv "XDBHOST") (list "-h" (getenv "XDBHOST")))))
(setq *dired-path* '("/work" "/src" "/phi" "/psi" "/chi"))

(require 'xdb)

; (require 'cygwin)
; (add-hook 'find-file-not-found-functions 'cygwin-file-not-found)

(defvar *pyflake* nil)

(defun pyflake (&optional arg)
  (interactive "p")

  ; TBD lazy load hairy python setups... 

  ; initialize if not already initialized, or called with arg or called interactively and confirmed
  (when 
      (or  
       (not *pyflake*)
       arg
       (and (called-interactively-p 'any) (y-or-n-p "python environment already initialized.  reinitialize?"))
       )

  ; set magic unbuffered flag needed for pdb to work as subprocess
  ; (setq gud-pdb-command-name "python -u -mpdb")
    (setenv "PYTHONUNBUFFERED" "true")
    (setq gud-pdb-command-name "python -mpdb")

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
		(setq python-indent-offset 4)))
  ; (pop python-mode-hook)

    (setq save-abbrevs 'silently)

; clobber key binding
    (defun my-run-python (&optional dedicated show) 
      (interactive)
      (let* ((process (python-shell-get-or-create-process))
	     (buffer (and process (process-buffer process))))
	(if (buffer-live-p buffer) (pop-to-buffer buffer) (run-python dedicated show) )
	)
      )
    (define-key ctl-RET-map  "\C-p" 'my-run-python)
    (setq *pyflake* t)
    )
  )

(define-key ctl-RET-map  "\C-p" 'pyflake)

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

(setq write-region-inhibit-fsync t)

(add-hook 'nxml-mode-hook
	  (lambda ()
	    (modify-syntax-entry ?{ "(" nxml-mode-syntax-table)
	    (modify-syntax-entry ?} ")" nxml-mode-syntax-table)
	    ))

;   browse-url-w3 will (require 'w3), so make sure it is on your load path.  
(setq browse-url-browser-function 'browse-url-w3)
; (add-to-list 'find-file-not-found-functions  '(lambda () (browse-url buffer-file-name)))

(load "color-theme-autoloads" nil t)
; (color-theme-hober)
; to scroll through available color themes
; (call-interactively 'doremi-color-themes+)

(mapc
 (lambda (x)
   (let* (
	  (load-directory (expand-file-name ".emacs.d" x))
	  (files (get-directory-files load-directory t ".el$")))
     (loop for y in files do
	   ;; todo prevent loading twice?
	   (let ((basename (file-name-sans-extension y)))
					; this is so if happens to be a compiled version in there, load that instead of the source
	     (load basename t t)
	     )
	   )
     )
   )
					; '("/z/w" "/z/sync")
 '("/z/sync")
 )

; if kbf can be found, call it
; (let ((kbf (executable-find "kbf")))  (and kbf (call-process kbf))  )

(require 'server)
(unless (eq (server-running-p "server") t) (server-start) )

; (require 'cases)

(require 'ctl-slash)
(define-key ctl-/-map "h" 'host-config)

(defun bootstrap-bookmark-jump-hosts () (interactive)
  (require 'bookmark)
  (bookmark-maybe-load-default-file) 
  (define-key ctl-RET-map "h" (lambda () (interactive) (bookmark-jump "hosts")))
  (bookmark-jump "hosts")
  )

(define-key ctl-RET-map "h" 'bootstrap-bookmark-jump-hosts)

; get rid of annoying bash bug when run as subprocess
; bash: cannot set terminal process group (-1): Inappropriate ioctl for device 

(if (executable-find "fakecygpty")
    (setq explicit-shell-file-name "fakecygpty"
	  explicit-fakecygpty-args '("bash" "-i"))
  )
