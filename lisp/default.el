(put 'default 'rcsid 
 "$Id: default.el,v 1.9 2000-11-20 01:03:02 cvs Exp $")

(mapcar 
 '(lambda (x) (and (file-directory-p x) (not (member x load-path)) (nconc load-path (list x))))
 (nconc (list 
	 (concat home "/emacs/config/hosts/" (hostname))
	 (concat home "/emacs/config/os/" (uname))
	 )
	(directory-files (concat home "/emacs/site-lisp") t "^[a-zA-Z]")
	(directory-files (concat emacsdir "/site-lisp") t "^[a-zA-Z]")
	)
 )

(require 'config) ; this feature should not be required for anything up to this point

(load "os-init" t t)		; load os-specific info

(or 
 (load (symbol-name window-system) t t)	; window system specific
 (load (getenv "TERM") t t)		;terminal specific
)

; emacs specific initialization
; epoch, lucid, and xemacs variants caused problems once upon a time, ...

(and (boundp 'emacs-major-version)
     (load (concat "Emacs" emacs-major-version) t t))

(load "keys" nil t) ;key bindings
(load "autoloads" nil t) ;automatically generated now

(setq doc-directory data-directory)

(modify-syntax-entry ?- "w")

(setq list-directory-verbose-switches "-alt")

(setq horizontal-scroll-delta 20)

(setq auto-mode-alist '(
			("\\.l$" . c++-mode) ; lex
			("\\.java$" . java-mode)
			("\\.pl$" . perl-mode)
			("\\.pm$" . perl-mode)
			("\\.pod$" . perl-mode)
			("\\.HTM$" . html-mode)
			("\\.htm$" . html-mode)
			("\\.HTML$" . html-mode)
			("\\.html$" . html-mode)
			("\\.sgm$" . sgml-mode)
			("\\.SGML$" . sgml-mode)
			("\\.sgml$" . sgml-mode)
			("\\.text$" . text-mode)
			("\\.txt$" . text-mode)
			("\\.s$" . c-mode)
			("\\.c$" . c++-mode)
  ;			("\\.lst$" . list-mode)
			("\\.h$" . c++-mode)
			("\\.tex$" . TeX-mode)
			("\\.el$" . emacs-lisp-mode)
			("\\.scm$" . scheme-mode) 
			("\\.lisp$" . lisp-mode)
			("\\.f$" . fortran-mode)
			("\\.mss$" . scribe-mode)
			("\\.TeX$" . TeX-mode)
			("\\.sty$" . LaTeX-mode)
			("\\.bbl$" . LaTeX-mode)
			("\\.bib$" . text-mode)
			("\\.article$" . text-mode)
			("\\.letter$" . text-mode)
			("\\.texinfo$" . texinfo-mode)
			("\\.lsp$" . lisp-mode)
			("\\.prolog$" . prolog-mode)
			("^/tmp/Re" . text-mode)
			("^/tmp/fol/" . text-mode) 
			("/Message[0-9]*$" . text-mode)
			("\\.y$" . c-mode)
			("\\.cc$" . c-mode) 
			("\\.scm.[0-9]*$" . scheme-mode)
			("[]>:/]\\..*emacs" . emacs-lisp-mode)
			("\\.ml$" . lisp-mode)
			("\\.pi$" . pi-mode) 
			("\\.fi$" . filelist-mode) 
			("\\.sh$" . fundamental-mode)
			("\\.se$" . se-mode)
			("\\.tlfmt[0-9]*$" . se-mode)
			("\\.cpp$" . c++-mode)
			("\\.hpp$" . c++-mode)
			("\\.c++$" . c++-mode)
			("\\.h++$" . c++-mode)
			("\\.C$" . c++-mode)
			("\\.H$" . c++-mode)
			("\\.hh$" . c++-mode)
			("\\.pgp$" . decrypt-mode)
			("\\.9[56]$" . logview-mode)
			("\\.Z$" . uncompress-while-visiting)
			("\\.gz$" . uncompress-while-visiting)
			("\\.tar$" . tar-mode)
			))

;;(add-auto-mode "\\.sh$" 'shell-mode)
(setq next-line-add-newlines nil)
(setq c-tab-always-indent nil)

; limits

(setq kill-ring-max 10000
      message-log-max 10000
      list-command-history-max 10000)

(modify-syntax-entry ?* "w" emacs-lisp-mode-syntax-table)

(add-hook 'write-file-hooks 'time-stamp)

(add-hook 'emacs-lisp-mode-hook '(lambda ()
				   (modify-syntax-entry ?- "w")
				   (modify-syntax-entry ?* "w")
;				   (set-tabs 2)
				   (setq comment-column 2)
				   ) 
	  t)


(require 'worlds)

(put 'eval-expression 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'upcase-region 'disabled nil)

(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq display-time-day-and-date t)


(menu-bar-mode -1)
(scroll-bar-mode -1)

;; optional host-specific overrides
(load "host-init" t t)
