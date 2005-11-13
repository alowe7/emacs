(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/tombstone/host-init.el,v 1.1 2005-11-13 15:42:40 cvs Exp $")

; enoch
; (require 'xz-loads)
(require 'cat-utils)
(display-time)

(defvar *xdpyinfo* nil)

(defun xdpyinfo (&optional attr)
  (unless *xdpyinfo*  (setq *xdpyinfo* (loop for x in  (split (eval-process "/usr/X11R6/bin/xdpyinfo") "
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

; (setq *perl-libs* (split (perl-command-2 "map {print \"$_ \"} @INC")))

(defvar perldir "/usr/lib/perl5/5.6.0")

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
(setq w3m-home-page "http://enoch")
; (load-library "w3m")

(load-library "ctl-slash")

(load-library "bookmark")
; xxx todo: figure out why post-bookmark doesn't get loaded
(load-library "post-bookmark")

(global-set-key "r" 'rmail)

(global-set-key (quote [f9]) (quote undo))

(setq *default-gpg-file*  "/nathan/d/a/.private/bang2")

(setq x-select-enable-clipboard t)

; lets move on... 
(global-set-key (vector 25165856) 'roll-buffer-list)

(defun compare-with-slash () (interactive)
  (find-file-other-window (concat "/slash" (buffer-file-name)))
  )
(define-key ctl-/-map "" 'compare-with-slash)