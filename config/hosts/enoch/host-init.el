(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/enoch/host-init.el,v 1.4 2004-02-24 19:47:28 cvs Exp $")

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
	    (setq initial-frame-alist '( (top . 72) (left . 43) (width . 70) (height . 45)))
	    (set-frame-width nil 70)
	    (set-frame-height nil 45)
	    (set-face-attribute 'default nil :font "-adobe-helvetica-medium-r-normal--17-120-100-100-p-88-iso8859-1")
	    )
	(set-face-attribute 'default nil :font "-adobe-helvetica-medium-r-normal--14-140-75-75-p-77-iso10646-1")
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
