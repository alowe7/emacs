(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/enoch/host-init.el,v 1.2 2004-01-27 20:03:14 cvs Exp $")

; enoch
(add-to-load-path "~x/elisp")

; (require 'xz-loads)
(require 'cat-utils)
(display-time)

(if (eq window-system 'x)
    (progn
      (set-background-color "white")
      (set-foreground-color "black")
      (set-face-attribute 'default nil :font "-adobe-helvetica-medium-r-normal--14-140-75-75-p-77-iso10646-1")
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
