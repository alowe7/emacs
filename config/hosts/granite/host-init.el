(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/granite/host-init.el,v 1.3 2010-04-17 18:53:08 alowe Exp $")

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(setq
 cursor-type (quote (bar . 1))
 cursor-in-non-selected-windows nil)

(set-default-font "-*-Corbel-normal-r-*-*-17-*-*-*-*-*-*-*")

(setq default-frame-alist initial-frame-alist)

(setq display-time-day-and-date t)
(display-time)

(add-to-load-path "/u/emacs-w3m-1.3.2")
(autoload 'w3m "w3m" "Interface for w3m on Emacs." t)

(add-to-load-path "/u/Mule-UCS-0.84/lisp/")

; all kinds of crap here
(add-to-load-path-p "/z/el" t)

; and some lisp here too
(add-to-load-path-p "/z/pl" t)

; defaults
(setq *gpg-command* "/usr/local/bin/gpg.exe")

; content on skull & crossbones
(setq *gpg-default-file*  "g:/wink")

; moved keyrings from gizmo to home
; (setq *gpg-default-homedir*  "j:/home/a/.gnupg")
(setq *gpg-default-homedir*  (expand-file-name "~/.private/.gnupg"))

(setq *gpg-encode-target* "Andrew")
(setq *gpg-extra-args* `("--homedir" ,*gpg-default-homedir*))

; find-script will look along path for certain commands 
(require 'path-utils)
(addpathp "/z/pl" "PATH")

; this ensure calendar comes up in a frame with a fixed-width font
(load-library "mycal")

; xxx check out why this isn't autoloading
(load-library "post-bookmark")

; (load-library "post-help")
(load-library "fixframe")
(load-library "unbury")

(if (not (and
	  (file-directory-p exec-directory)
	  (string-match (format "%s.%s" emacs-major-version emacs-minor-version) exec-directory)))
    (let ((dir (or (getenv "EMACS_DIR") (getenv "EMACSDIR"))))
      (or (string= exec-directory dir)
	  (setq exec-directory dir))
      )
  )

(setq Info-default-directory-list '("/usr/local/lib/emacs-23.1/info" "/usr/share/info"))
(setq Info-directory-list  Info-default-directory-list)

(autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t)
(autoload 'xml-mode "psgml" "Major mode to edit XML files." t)

(scan-file-p "~/.private/.xdbrc")

; this is a problem..
(defun perl-font-lock-syntactic-keywords ()  perl-font-lock-syntactic-keywords) 

(require 'noted)
(require 'locations)
(require 'emacs-wiki-load)

(load-library "locate")

; should be found in /usr/share/emacs/site-lisp/zt-1.0
; (add-to-load-path-p "/z/db" t)

(require 'zt-loads)
(require 'xz-loads)

(setq dired-dnd-protocol-alist nil)

; (setq comint-use-prompt-regexp t)

; for now...
(load-library "post-comint")


