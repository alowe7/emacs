(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/lt-alowe/host-init.el,v 1.8 2008-11-15 20:45:23 alowe Exp $")

(tool-bar-mode -1)
(menu-bar-mode -1)

(setq default-fontspec
      (default-font 
	(setq default-font-family "tahoma")
	(setq default-style "normal")
	(setq default-point-size 16))
      )
; "-outline-tahoma-normal-r-normal-normal-16-120-96-96-p-70-*-"

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

(scan-file-p "~/.private/.xdbrc")
;; (require 'proxy-autoconfig)
;; (if (let ((ip (myIpAddress)))
;;       (or (isInNet "10.0.0.0/255" ip) (isInNet "10.0.0.0/255" ip)))
;; ...)

(setq *txdb-options* 
      (let (l)
	(and (string* (getenv "XDBHOST")) (setq l (nconc l (list "-h" (getenv "XDBHOST")))))
	(and (string* (getenv "XDB")) (setq l (nconc l (list "-b" (getenv "XDB") ))))
	)
      )

(require 'gnuserv)

; this shortens the timeout for \\localdir\file being interpreted as \\host\file
(mount-hook-file-commands)

(defvar grep-command "grep -n -i -e ")

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
(load-library "people")
(load-library "locate")
(load-library "dired")

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

; xxx mongrify
(add-hook 'locate-mode-hook 'fb-mode)

; honk?
(setq wlog (expand-file-name "~/tw/wlog"))
(setq wdirs (list "/z"))

(setq Info-default-directory-list  '("/usr/share/info/" "c:/usr/local/lib/emacs-21.3/info/" "/usr/local/share/info/"))

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

(load-library "xz-loads")


(setq sgml-default-doctype-name  "-//W3C//DTD XHTML 1.0 Transitional//EN")
(setq sgml-catalog-files '("/a/lib/DTD/catalog"))
(add-auto-mode "\\.csproj$" 'xml-mode)

(global-font-lock-mode 1)

; for now...
(require 'cs-mode)
(add-auto-mode "\\.cs$" 'cs-mode)
