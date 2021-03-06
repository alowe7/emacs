(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/tombstone/host-init.el,v 1.17 2007-12-30 02:00:36 tombstone Exp $")

; enoch..tombstone

(require 'long-comment)

(require 'xz-loads)
(require 'cat-utils)
(require 'gnuserv)
(setq display-time-day-and-date t)
(display-time)

(defvar *xdpyinfo* nil)

(defun xdpyinfo (&optional attr)
  (unless *xdpyinfo*  (setq *xdpyinfo* (loop for x in  (split (eval-process "/usr/X11R6/bin/xdpyinfo") "
") collect (split x ":"))))
  (if attr (assoc attr *xdpyinfo*) *xdpyinfo*))

(scroll-bar-mode -1)

(setenv "PERL5LIB" "/usr/local/site-lib/perl")

; (require 'xz-loads)

(defun evilnat () t)

(setq mail-default-reply-to "alowe7@alowe.com")

(and (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(and (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(global-set-key (vector 'f2) (lambda () (interactive) (shell2 2)))

; (setq comint-use-prompt-regexp-instead-of-fields nil)

; (add-to-load-path "/usr/local/src/emacs-w3m/emacs-w3m" t)
; (setq w3m-home-page "http://tombstone")
; (setq w3m-home-page "http://www.alowe.com")
(setq w3m-home-page "about:blank")
; (load-library "w3m")

(require 'ctl-slash)
(require 'ctl-ret)

(load-library "bookmark")
; xxx todo: figure out why post-bookmark doesn't get loaded
(load-library "post-bookmark")

(global-set-key "r" 'rmail)

(global-set-key (quote [f9]) (quote undo))

(setq x-select-enable-clipboard t)

; lets move on... 
(global-set-key (vector 25165856) 'roll-buffer-list)

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
(setq *gpg-command* (whence "gpg"))
; (setq *gpg-default-file*  "~/.private/wink")
(setq *gpg-default-file*  "/nathan/g/wink")
; (setq *gpg-default-homedir*  "~/.private/.gnupg")
(setq *gpg-default-homedir*  "/nathan/g/.gnupg")
(setq *gpg-encode-target* "Andrew")
(setq *gpg-extra-args* `("--homedir" ,*gpg-default-homedir*))

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


(defun w3m-view-file (f)
  (interactive)
  (let* ((b (zap-buffer (concat (file-name-sans-extension (file-name-nondirectory f)) " *w3m*"))))
    (shell-command (format "w3m %s" f) b)
    (pop-to-buffer b)
    (beginning-of-buffer)
    (view-mode)
    )
  )

(add-file-association "htm" 'w3m-view-file)
(add-file-association "html" 'w3m-view-file)

; (pop file-assoc-list)

; for some reason the fontspec isn't computing the char width correctly
(if (eq window-system 'x) (setenv "COLUMNS" "132"))

(global-set-key (vector ?) 'undo)
(global-set-key (vector ?\C-c ?\C-j) 'font-lock-fontify-buffer)

(defun email ()
  (interactive)
  (require 'defun-maybe) ; this is broken in pym.el
  (vm-visit-inbox)
  )

;; user-mail-address is initialized from user-login-name, and system-name or mail-host-address
;; see /usr/share/emacs/21.4/lisp/startup.el

;; these will likely be the wrong thing to use, so just clobber it
(let* ((username (user-login-name))
       (system-name (system-name))
       (domainname (if (string-match (concat (hostname-non-domain) ".") system-name)
		       (substring system-name (match-end 0))
		     system-name)))

  (if (string* username (string= username "root"))
      (setq username (user-login-name 500)))


  (setq user-mail-address (concat username "@" domainname)
	mail-specify-envelope-from t
	)
  )

; use locate for everything else
(setq  *fb-db* "/backup/f")

(setq grep-command "grep -n -i -e ")
(setq jit-lock-stealth-time 1)

