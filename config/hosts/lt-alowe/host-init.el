(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/lt-alowe/host-init.el,v 1.27 2010-05-16 20:30:49 alowe Exp $")

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(setq
 cursor-type (quote (bar . 1))
 cursor-in-non-selected-windows nil)


; tweak load-path to use working versions if found. will this stuff ever stabilize?
(setq tweaked-loads
      '(
	("site-lisp/tw-3.01" "/x/tw/site-lisp")
	("site-lisp/db-1.0" "/x/db/site-lisp")
	("site-lisp/xz-3.1" "/x/xz/site-lisp")
	("site-lisp/tx-1.0" "/x/elisp")
	("site-lisp/x-1.0" "/x/share/site-lisp")
	))

(defvar *sisdirs* nil) ;; just in case its not defined yet
(loop
 for e in tweaked-loads 
 do
 (add-to-list '*sisdirs* (list (unix-canonify (expand-file-name (car e) share) 0) (cadr e)))
 )

; todo rationalize this loop with previous
(loop for e in tweaked-loads
      when (file-directory-p (cadr e))
      do 
      (setq load-path
  ; first remove published versions, if any
	    (nconc (remove-if '(lambda (x) (string-match (car e) x)) load-path)
  ; then add working versions
		   (cdr e))
	    )
      )

(display-time)

(require 'trim)
(require 'sh)

; (require 'worlds)
; (require 'world-advice)

(load-library "people")

(/*
  ; todo: be smarter about using http_proxy with w3m
 (scan-file-p "~/.private/.xdbrc")
  ; (string-match (i2n myIP) myIP)
  ; (isinnet myIP "10.0.0.0/255")
  ; (isinnet myIP "192.168.1.0/255.255.255.0")
 )

(add-to-load-path  "/z/el" t)

(setq *txdb-options* 
      (let (l)
	(and (string* (getenv "XDBHOST")) (setq l (nconc l (list "-h" (getenv "XDBHOST")))))
	(and (string* (getenv "XDB")) (setq l (nconc l (list "-b" (getenv "XDB") ))))
	)
      )

(require 'gnuserv)

; this shortens the timeout for \\localdir\file being interpreted as \\host\file
; (mount-hook-file-commands)

(setq grep-command "grep -nH -i -e ")

(setq *advise-help-mode-finish* t)

(add-hook 'perl-mode-hook
	  '(lambda () (font-lock-mode t)))

(defun makeunbound (symbol-name)
  (interactive (list (read-string* "make unbound (%s): " (thing-at-point 'symbol))))
  (let ((symbol (intern symbol-name)))
    (and (boundp symbol) (makunbound symbol))
    )
  )
(define-key ctl-/-map "u" 'makeunbound)

; make f1 available for binding
(if (eq (key-binding (vector 'f1)) 'help-command)
    (global-set-key (vector 'f1) nil))

(defun undedicate-window () 
(interactive)
(set-window-dedicated-p (selected-window) nil))

; its a lie.  
(autoload 'calendar "mycal")

; force post-load hooks now... tbd find a better way
(post-after-load "locate")
(post-after-load "dired")

(defvar *path-sep* ";")

(defun add-to-path (dir &optional prepend)
  (unless (member dir (split (getenv "PATH") *path-sep*))
    (setenv "PATH" 
	    (concat (getenv "PATH") *path-sep* dir)
	    ))
  )

; (add-to-path "c:\\Program Files\\Java\\j2re1.4.2_03\\bin")
; (add-to-path "c:\\Program Files\\Java\\j2re1.4.2_03\\bin" t)

(setq *minibuffer-display-unique-hit* t)

; gpg is here
(add-to-load-path "/z/gpg" t)
(setq *gpg-default-homedir*  (expand-file-name "i:/home/a/.gnupg"))
(condition-case x (load "/z/gpg/.autoloads") (error nil))
(setq *gpg-command* "/home/a/bin/gpg.exe")
(setq *gpg-default-file*  "f:/wink")
; (setq *gpg-default-homedir*  "~/.gnupg")
(setq *gpg-encode-target* "Andrew Lowe")
(setq *gpg-extra-args* `("--homedir" ,*gpg-default-homedir*))

(require 'logview-mode)

(require 'myblog)

; string quoting logic in font-lock if f***-ed up

(setq font-lock-string-face 'default)

; xxx mongrify
(add-hook 'locate-mode-hook 'fb-mode)

; honk?
(setq wlog (expand-file-name "~/tw/wlog"))
(setq wdirs (list "/z"))

(setq Info-default-directory-list
      `(
	"/usr/share/info/"
	,(canonify (expand-file-name "info"  (getenv "EMACS_DIR")) 0)
	"/usr/local/share/info/")
      )


; struggling with daylight savings time again
; (getenv "TZ")
; (current-time-zone)
(set-time-zone-rule "CST6CDT")
; (set-time-zone-rule "EST5EDT")
; (format-time-string "%H"  (current-time))

(add-to-load-path "/z/db" t)
(load-library "zt")
; (find-whence-lib "zt.el")

(define-key ctl-RET-map "" 'yank-like)


(unless (get 'post-comint 'rcsid)
  (load-library "post-comint"))

(defun isearch-thing-at-point ()
  (interactive)
  (isearch-update-ring (thing-at-point 'symbol))
  (isearch-forward)
  )
(define-key ctl-RET-map "\C-s" 'isearch-thing-at-point)

(setq sgml-default-doctype-name  "-//W3C//DTD XHTML 1.0 Transitional//EN")
(setq sgml-catalog-files '("/a/lib/DTD/catalog"))
(add-auto-mode "\\.csproj$" 'xml-mode)

(global-font-lock-mode 1)

; for now...
(require 'cs-mode)
(add-auto-mode "\\.cs$" 'cs-mode)



; (add-to-list 'warning-suppress-types '(undo discard-info))

; (setenv "PATH" (concat (getenv "PATH") ";c:\\usr\\local\\lib\\tw-3.01\\bin"))

(setenv "JAVA_HOME" "c:/Program Files/Java/jre1.6.0_03")

(setenv "ANT_HOME"  "/usr/local/lib/apache-ant-1.6.5")
(defvar *ant-command* (substitute-in-file-name "$ANT_HOME/bin/ant "))
(defvar *make-command* "make -k ")
(setq compile-command *ant-command*)
(make-variable-buffer-local 'compile-command)
(set-default 'compile-command  *ant-command*)

; advice won't work to tweak an interactive form
(unless (and (boundp 'orig-compile) orig-compile)
  (fset 'orig-compile (symbol-function 'compile)))
(define-key ctl-x-map (vector 'C-S-return) 'orig-compile)

(defun compile (command)
  "hook compile to call make if default-directory contains a makefile, ant otherwise
see `orig-compile'
"
  (interactive
   (let ((compile-command
	  (or 
	   (cdr (assq (quote compile-command) (buffer-local-variables)))
	   (and (file-exists-p "Makefile") *make-command*) compile-command)))
     (if (or compilation-read-command current-prefix-arg)
	 (list (read-from-minibuffer "Compile command: "
				     (eval compile-command) nil nil
				     '(compile-history . 1)))
       (list (eval compile-command)))))

  (orig-compile command)
  )

; this is bogus:
; (define-key isearch-mode-map "\M-y" (car kill-ring))

; (debug)
;; what a coincidence.  two machines same name
; (require 'xz-loads)
(add-hook 'xz-load-hook 
	  '(lambda ()
	     (mapcar
	      '(lambda (x) (load x t t)) 
		     '("xz-compound" "xz-fancy-keys" "xz-constraints"))))

; why load when you can require?
; (load-library "xz-loads")
(require 'xz-loads)

(defvar  locate-options '("--ignore-case"))
(defun my-locate-default-make-command-line (search-string)
  `(,locate-command ,@locate-options ,search-string))
(setq locate-make-command-line 'my-locate-default-make-command-line)
; (funcall locate-make-command-line "foo")

(add-to-load-path "." t)

(setq default-buffer-file-coding-system 'undecided-unix)

; not sure if this isn't just masking a bug
(define-key isearch-mode-map "\C-m" 'isearch-exit)
