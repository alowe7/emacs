(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/granite/host-init.el,v 1.7 2010-10-02 21:53:57 alowe Exp $")

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(setq
 cursor-type (quote (bar . 1))
 cursor-in-non-selected-windows nil)

(setq default-font  "-*-Corbel-normal-r-*-*-17-*-*-*-*-*-*-*")
(set-default-font default-font)
(setq initial-frame-alist
      `(
	(top . ,(truncate (* (frame-height) 0.2)))
	(left . ,(truncate (* (frame-width) 0.2)))
	(width . ,(truncate (* (frame-width) 0.8)))
	(height . ,(truncate (* (frame-height) 0.8)))
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
	(font . ,default-font)
	(menu-bar-lines . 0))
      )
 (setq default-frame-alist  initial-frame-alist)

(display-time)

; (require 'trim)
; (require 'sh)

; (require 'worlds)
; (require 'world-advice)

; (load-library "people")

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

(setq *gpg-default-homedir*  (expand-file-name "c:/home/a/.gnupg"))
(condition-case x (load "/z/gpg/.autoloads") (error nil))
(setq *gpg-command* "/usr/local/bin/gpg.exe")
(setq *gpg-default-file*  "j:/wink")
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

; (find-whence-lib "zt.el")

(defun isearch-thing-at-point ()
  (interactive)
  (isearch-update-ring (thing-at-point 'symbol))
  (isearch-forward)
  )

; tbd clean this up...
(setq sgml-default-doctype-name  "-//W3C//DTD XHTML 1.0 Transitional//EN")
(setq sgml-catalog-files (list (canonify (expand-file-name "~/lib/DTD/catalog") 0))
(add-auto-mode "\\.csproj$" 'xml-mode)

(global-font-lock-mode 1)

; for now...
(require 'cs-mode)
(add-auto-mode "\\.cs$" 'cs-mode)


; (add-to-list 'warning-suppress-types '(undo discard-info))

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

; until I figure out what's the deal with perl-mode
(setq global-font-lock-mode nil)
