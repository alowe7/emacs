(put 'default 'rcsid 
 "$Id: default.el,v 1.17 2001-07-16 17:47:19 cvs Exp $")

(defvar post-load-hook nil "hook to run after initialization is complete")

(setq home (expand-file-name (getenv "HOME")))
(setq emacsdir (expand-file-name (getenv "EMACSDIR")))
(setq share  (expand-file-name (getenv "SHARE")))
(setq doc-directory data-directory)
(require 'uname)

(mapcar 
 '(lambda (x) (and (file-directory-p x)
		   (not (member x load-path))
		   (not (string-match "/CVS$" x))
		   (nconc load-path (list (expand-file-name x)))))

 (nconc (list 
	 (concat home "/emacs/config/hosts/" (hostname))
	 (concat home "/emacs/config/os/" (uname))
	 )
	(directory-files (concat home "/emacs/site-lisp") t "^[a-zA-Z]")
	(directory-files (concat emacsdir "/site-lisp") t "^[a-zA-Z]")
	(directory-files (concat share "/emacs/site-lisp") t "^[a-zA-Z]")
	)
 )

(load "autoloads" nil t) ;automatically generated now

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

(modify-syntax-entry ?- "w")

(setq list-directory-verbose-switches "-alt")

(setq horizontal-scroll-delta 20)

;; sort in order of decreasing frequency
(setq auto-mode-alist '(
			("\\.HTM$" . html-mode)
			("\\.htm$" . html-mode)
			("\\.HTML$" . html-mode)
			("\\.html$" . html-mode)
			("\\.txt$" . text-mode)
			("\\.el$" . emacs-lisp-mode)
			("\\.c$" . c++-mode)
			("\\.h$" . c++-mode)
			("\\.idl$" . c++-mode) ; lex
			("\\.l$" . c++-mode) ; lex
			("\\.java$" . java-mode)
			("\\.pl$" . perl-mode)
			("\\.pm$" . perl-mode)
			("\\.pod$" . perl-mode)
			("\\.shtml$" . html-mode)
			("\\.sgm$" . sgml-mode)
			("\\.SGML$" . sgml-mode)
			("\\.sgml$" . sgml-mode)
			("\\.xml$" . sgml-mode)
			("\\.xsl$" . sgml-mode)
			("\\.s$" . c-mode)
			("\\.TeX$" . TeX-mode)
			("\\.sty$" . LaTeX-mode)
			("\\.bbl$" . LaTeX-mode)
			("\\.bib$" . text-mode)
			("\\.article$" . text-mode)
			("\\.letter$" . text-mode)
			("\\.texinfo$" . texinfo-mode)
			("\\.lsp$" . lisp-mode)
			("\\.prolog$" . prolog-mode)
			("\\.text$" . text-mode)
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
  ;			("\\.lst$" . list-mode)
			("\\.tex$" . TeX-mode)
			("\\.scm$" . scheme-mode) 
			("\\.lisp$" . lisp-mode)
			("\\.f$" . fortran-mode)
			("\\.mss$" . scribe-mode)
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


(put 'eval-expression 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'upcase-region 'disabled nil)


(menu-bar-mode -1)
(scroll-bar-mode -1)

;; optional host-specific overrides
(load "host-init" t t)

(run-hooks 'post-load-hook)
