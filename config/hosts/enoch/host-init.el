(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/enoch/host-init.el,v 1.9 2005-01-04 03:26:57 cvs Exp $")

; enoch
; (require 'xz-loads)
(require 'cat-utils)
(display-time)

(defvar *xdpyinfo* nil)

(defun xdpyinfo (&optional attr)
  (unless *xdpyinfo*  (setq *xdpyinfo* (loop for x in  (split (eval-process "xdpyinfo") "
") collect (split x ":"))))
  (if attr (assoc attr *xdpyinfo*) *xdpyinfo*))

; (string-match "Hummingbird Ltd."  (cadr (xdpyinfo "vendor string")))

(if (eq window-system 'x)
    (progn
  ;      (set-background-color "white")
  ;      (set-foreground-color "black")
  ; hummingbird sets up different fonts from xfree86
      (if (string-match "Hummingbird Ltd."  (cadr (xdpyinfo "vendor string")))
	  (progn
	    (setq initial-frame-alist 
		  '(
		    (top . 56)
		    (left . 70)
		    (width . 47)
		    (height . 28)
		    (font . "-adobe-helvetica-medium-r-normal--17-120-100-100-p-88-iso8859-1")))
	    (set-frame-width nil 47)
	    (set-frame-height nil 28)
	    (set-face-attribute 'default nil :font "-adobe-helvetica-medium-r-normal--17-120-100-100-p-88-iso8859-1")
	    )
	(progn
	  (setq default-font
		"lucidasanstypewriter-14"
  ; "-b&h-lucida-medium-r-normal-sans-18-180-75-75-p-106-iso10646-1"
		)
	  (set-default-font default-font)
	  (set-face-attribute 'default nil :font default-font)
	  )
	)
      )
  )


(scroll-bar-mode -1)

; (add-to-list 'Info-default-directory-list "/simon/e/usr/local/lib/info" )
(setenv "PERL5LIB" "/usr/local/site-lib/perl")

; (require 'xz-loads)
; (define-key xz-map "" 'xz-query-format)

(setq *perl-libs* (split (perl-command-2 "map {print \"$_ \"} @INC")))

(defvar perldir "/usr/lib/perl5/5.6.0")

(setq w3m-home-page "http://enoch")

(defun evilnat () t)

(setq mail-default-reply-to "a@alowe.com")

(and (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(and (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(defun nautilus ()
  (interactive)
  (call-process "/usr/bin/nautilus" nil nil nil default-directory)
  )
(global-set-key (vector 'f12) 'nautilus)
(global-set-key (vector 'f2) '(lambda () (interactive) (shell2 2)))

; (setq comint-use-prompt-regexp-instead-of-fields nil)
; (add-to-load-path "/usr/local/src/emacs-w3m/emacs-w3m" t)
(load-library "ctl-slash")
