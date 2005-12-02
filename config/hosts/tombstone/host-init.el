(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/tombstone/host-init.el,v 1.3 2005-12-02 01:53:58 tombstone Exp $")

; enoch
; (require 'xz-loads)
(require 'cat-utils)
(require 'gnuserv)
(display-time)

(defvar *xdpyinfo* nil)

(defun xdpyinfo (&optional attr)
  (unless *xdpyinfo*  (setq *xdpyinfo* (loop for x in  (split (eval-process "/usr/X11R6/bin/xdpyinfo") "
") collect (split x ":"))))
  (if attr (assoc attr *xdpyinfo*) *xdpyinfo*))

;; 
;;  ;; not sure what's wrong here... set-default-font and set-face-attribute are taking forever
;; 
;; ; (string-match "Hummingbird Ltd."  (cadr (xdpyinfo "vendor string")))
;; 
;; (if (eq window-system 'x)
;;   ;      (set-background-color "white")
;;   ;      (set-foreground-color "black")
;;   ; hummingbird sets up different fonts from xfree86
;;     (if (string-match "Hummingbird Ltd."  (cadr (xdpyinfo "vendor string")))
;; 	(progn
;; 	  (setq initial-frame-alist 
;; 		'(
;; 		  (top . 56)
;; 		  (left . 70)
;; 		  (width . 47)
;; 		  (height . 28)
;; 		  (font . "-adobe-helvetica-medium-r-normal--17-120-100-100-p-88-iso8859-1")))
;; 	  (set-frame-width nil 47)
;; 	  (set-frame-height nil 28)
;; 	  (set-face-attribute 'default nil :font "-adobe-helvetica-medium-r-normal--17-120-100-100-p-88-iso8859-1")
;; 	  )
;;       )
;; 
;;   ;;       (progn
;;   ;; 	(setq default-font
;;   ;; 	      "-adobe-helvetica-medium-r-normal--17-120-100-100-p-88-iso8859-1"
;;   ;;   ; "lucidasanstypewriter-14"
;;   ;;   ; "-b&h-lucida-medium-r-normal-sans-18-180-75-75-p-106-iso10646-1"
;;   ;; 	      default-frame-alist
;;   ;; 	      `(
;;   ;; 		(top . 56)
;;   ;; 		(left . 70)
;;   ;; 		(width . 47)
;;   ;; 		(height . 28)
;;   ;; 		(vertical-scroll-bars)
;;   ;; 		(tool-bar-lines . 0)
;;   ;; 		(menu-bar-lines . 0)
;;   ;; 		(font . ,default-font))
;;   ;; 	      initial-frame-alist  
;;   ;; 	      default-frame-alist
;;   ;; 	      )
;;   ;; 	(set-default-font default-font)
;;   ;; 	(set-face-attribute 'default nil :font default-font)
;;   ;; 	(set-frame-width nil 47)
;;   ;; 	(set-frame-height nil 28)
;;   ;; 	)
;;   ;;
;;   )
;; 

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

(if (file-exists-p "~/.private/.xdbrc")
    (scan-file "~/.private/.xdbrc"))

; all kinds of crap here
(add-to-load-path "/z/el" t)
(condition-case x (load "/z/el/.autoloads") (error nil))

; and some lisp here too
(add-to-load-path "/z/pl" t)
(condition-case x (load "/z/pl/.autoloads") (error nil))

; gpg is here
(add-to-load-path "/z/gpg" t)
(condition-case x (load "/z/gpg/.autoloads") (error nil))

; and some here too
(condition-case x (load "/z/soap/.autoloads") (error nil))

; find-script will look along path for certain commands 
(addpathp "/z/pl" "PATH")

; this ensure calendar comes up in a frame with a fixed-width font
(load-library "mycal")

(load-library "fixframe")
(load-library "unbury")

; (autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t)
; (autoload 'xml-mode "psgml" "Major mode to edit XML files." t)

