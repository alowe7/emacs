(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/lt-alowe/host-init.el,v 1.33 2010-09-24 01:19:40 alowe Exp $")

(require 'ctl-slash)
(require 'trim)

; prefer X resources, Windows registry, or command line options, in that order.
; see:
;  (info "(emacs) Table of Resources")
;  (info "(emacs) MS-Windows Registry")

; (tool-bar-mode -1)
; (menu-bar-mode -1)
; (scroll-bar-mode -1)

; does not appear to be resources for the following
(setq
 cursor-type (quote (bar . 1))
 cursor-in-non-selected-windows nil
 resize-mini-windows nil
)

(display-time)


; (require 'worlds)
; (require 'world-advice)
; (load-library "people")

(setq *gnuserv-dired-files* t)
(require 'gnuserv)

; this shortens the timeout for \\localdir\file being interpreted as \\host\file
; (mount-hook-file-commands)

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

; its a lie.  permit special frame handling
(autoload 'calendar "mycal")
(autoload 'w3m "myw3m")

; force post-load hooks now... tbd find a better way
(post-after-load "locate")

(defvar *path-sep* ";")

(defun add-to-path (dir &optional prepend)
  (unless (member dir (split (getenv "PATH") *path-sep*))
    (setenv "PATH" 
	    (concat (getenv "PATH") *path-sep* dir)
	    ))
  )

(setq *minibuffer-display-unique-hit* t)

; gpg is here
; (add-to-load-path "/z/gpg" t)
; (setq *gpg-default-homedir*  (expand-file-name "i:/home/a/.gnupg"))
; (condition-case x (load "/z/gpg/.autoloads") (error nil))
; (setq *gpg-command* "/home/a/bin/gpg.exe")
; (setq *gpg-default-file*  "f:/wink")
; (setq *gpg-default-homedir*  "~/.gnupg")
; (setq *gpg-encode-target* "Andrew Lowe")
; (setq *gpg-extra-args* `("--homedir" ,*gpg-default-homedir*))

(require 'logview-mode)

(require 'myblog)

; string quoting logic in font-lock if f***-ed up

(setq font-lock-string-face 'default)

; xxx mongrify
(add-hook 'locate-mode-hook 'fb-mode)

; honk?
(setq wlog (expand-file-name "~/tw/wlog"))
(setq wdirs (list "/work"))

(setq Info-default-directory-list
      `(
	"/usr/share/info/"
	,(canonify (expand-file-name "info"  (getenv "EMACS_DIR")) 0)
	"/usr/local/share/info/")
      )


; struggling with daylight savings time again
(set-time-zone-rule "CST6CDT")

(define-key ctl-RET-map "" 'yank-like)

(defun isearch-thing-at-point ()
  (interactive)
  (isearch-update-ring (thing-at-point 'symbol))
  (isearch-forward)
  )
(define-key ctl-RET-map "\C-s" 'isearch-thing-at-point)

(setq sgml-default-doctype-name  "-//W3C//DTD XHTML 1.0 Transitional//EN")
(setq sgml-catalog-files '("/a/lib/DTD/catalog"))

(global-font-lock-mode 1)

(add-hook 'xz-load-hook 
	  '(lambda ()
	     (mapcar
	      '(lambda (x) (load x t t)) 
		     '("xz-compound" "xz-fancy-keys" "xz-constraints"))))

; why load when you can require?
(require 'xz-loads)

(defvar  locate-options '("--ignore-case"))
(defun my-locate-default-make-command-line (search-string)
  `(,locate-command ,@locate-options ,search-string))
(setq locate-make-command-line 'my-locate-default-make-command-line)
; (funcall locate-make-command-line "foo")

(add-to-load-path "." t)

(setq buffer-file-coding-system 'undecided-unix)

; not sure if this isn't just masking a bug
(define-key isearch-mode-map "\C-m" 'isearch-exit)


; (see ~/emacs/config/23/view-images.el)

; (when (fboundp 'switch-to-image-in-frame)
;   (switch-to-image-in-frame "/content/images/peak7.jpg")
;  )


(setq 
 bookmark-default-file
 (expand-file-name ".emacs.bmk" (file-name-directory (locate-config-file "host-init")))
 )

(add-to-list 'load-path "/u/emacs-w3m/")
(setq w3m-command "/u/w3m-0.5.2/w3m.exe")

(setq temporary-file-directory "/tmp")

; hook preloaded modules
(mapc
 (lambda (x) (and (featurep x)  (post-load x)))
 '(comint)
 )
