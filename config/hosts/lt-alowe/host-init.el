(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/lt-alowe/host-init.el,v 1.2 2008-02-03 22:22:12 alowe Exp $")

(setq default-fontspec
      (default-font 
	(setq default-font-family "tahoma")
	(setq default-style "normal")
	(setq default-point-size 16))
      )

(setq initial-frame-alist
      `((top . 79)
 	(left . 100)
 	(width . 100)
 	(height . 32)
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
	(font . ,default-fontspec)
	(menu-bar-lines . 0))
      )

(setq default-frame-alist  initial-frame-alist)

; re-added top and left.
; see frames.el  
(setq *clone-frame-parameters* '(
				  ; window-id
				  top
				  left
				  ; buffer-list
				  ; minibuffer
				   width
				   height
				  ; name
				   display
				   visibility
				  ; icon-name
				  ; unsplittable
				  ; modeline
				   background-mode
				   display-type
				   scroll-bar-width
				   cursor-type
				  ; auto-lower
				  ; auto-raise
				   icon-type
				  ; title
				  ; buffer-predicate
				   tool-bar-lines
				   menu-bar-lines
				   line-spacing
				   screen-gamma
				   border-color
				   cursor-color
				   mouse-color
				   background-color
				   foreground-color
				   vertical-scroll-bars
				   internal-border-width
				   border-width
				   font
				   )
)


; tweak load-path to use working versions if found. will this stuff ever stabilize?
(loop for e in '(
		 ("site-lisp/tw-3.01" "/x/tw/site-lisp")
		 ("site-lisp/db-1.0" "/x/db/site-lisp")
		 ("site-lisp/xz-3.1" "/x/xz/site-lisp")
		 ("site-lisp/tx-1.0" "/x/elisp")
		 )
      when (file-directory-p (cadr e))
      do 
      (setq load-path
  ; first remove published versions, if any
	    (nconc (remove-if '(lambda (x) (string-match (car e) x)) load-path)
  ; then add working versions
		   (cdr e))
	    )
      )

(add-to-load-path "/z/el" t)

(add-hook 'xz-load-hook 
	  '(lambda ()
	     (mapcar
	      '(lambda (x) (load x t t)) 
		     '("xz-compound" "xz-fancy-keys" "xz-constraints"))))


(display-time)

(require 'trim)
(require 'sh)

; (require 'worlds)
; (require 'world-advice)

;; what a coincidence.  two machines same name
(require 'xz-loads)

;; (setq *xz-show-status* nil)
;; (setq *xz-squish* 4)
;; 
;; (scan-file-p "~/.xdbrc")
;; 
;; (if (and (not (evilnat)) 
;; 	 (string* (getenv "XDBHOST"))
;; 	 (string* (getenv "XDBDOMAIN"))
;; 	 (not (string-match (getenv "XDBDOMAIN") (getenv "XDBHOST"))))
;;     (setenv "XDBHOST" (concat (getenv "XDBHOST") "." (getenv "XDBDOMAIN"))))
;; 

(require 'gnuserv)

; this shortens the timeout for \\localdir\file being interpreted as \\host\file
(mount-hook-file-commands)

(defvar grep-command "grep -n -i -e ")

(setq *advise-help-mode-finish* t)

(defvar *ant-command* "/usr/local/lib/apache-ant-1.6.5/bin/ant ")
(defvar *make-command* "make -k ")
(setq compile-command *ant-command*)
(make-variable-buffer-local 'compile-command)
(set-default 'compile-command  *ant-command*)

; advice won't work to tweak an interactive form
(unless (and (boundp 'orig-compile) orig-compile)
  (setq orig-compile (symbol-function 'compile)))
(defun compile (command)
  "hook compile to call make if default-directory contains a makefile, ant otherwise"
  (interactive
   (let ((compile-command
	  (or (and (file-exists-p "Makefile") *make-command*) compile-command)))
     (if (or compilation-read-command current-prefix-arg)
	 (list (read-from-minibuffer "Compile command: "
				     (eval compile-command) nil nil
				     '(compile-history . 1)))
       (list (eval compile-command)))))

  (funcall orig-compile command)
  )

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

; force post-load hook now
(load-library "people")

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
(setq *gpg-default-homedir*  (expand-file-name "~/.private/gnupg"))
(condition-case x (load "/z/gpg/.autoloads") (error nil))
(setq *gpg-command* "/home/alowe/bin/gpg.exe")
(setq *gpg-default-file*  "~/.private/wink")
; (setq *gpg-default-homedir*  "~/.gnupg")
(setq *gpg-encode-target* "Andrew Lowe")
(setq *gpg-extra-args* `("--homedir" ,*gpg-default-homedir*))

(require 'logview-mode)

(require 'myblog)

; string quoting logic in font-lock if f***-ed up

(setq font-lock-string-face 'default)

(setq Info-default-directory-list
      '("/usr/local/info/" "c:/usr/local/lib/emacs-21.3/info/" "/usr/local/share/info/")
      )

; xxx mongrify
(add-hook 'locate-mode-hook 'fb-mode)

; honk?
(setq wlog (expand-file-name "~/tw/wlog"))
(setq wdirs (list "/z"))