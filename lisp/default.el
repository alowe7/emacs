(put 'default 'rcsid 
 "$Id: default.el,v 1.22 2002-02-13 21:48:11 cvs Exp $")

(defvar post-load-hook nil "hook to run after initialization is complete")

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
			("\\.xml$" . xml-mode)
			("\\.xsl$" . xml-mode)
			("\\.wsdl$" . xml-mode)
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

(add-hook 'sh-mode-hook '(lambda () (use-local-map nil)))

(put 'eval-expression 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'upcase-region 'disabled nil)

(menu-bar-mode -1)
(scroll-bar-mode -1)

(defun select-frame-parameters ()
  "build a default frame alist with selected values from current frame's parameters"
  (interactive)
  (let ((l (loop for x in default-frame-alist
		 collect
		 (cons (car x) (frame-parameter nil (car x))))))
    (setq default-frame-alist l)
    (describe-variable 'default-frame-alist)
    )
  )

(run-hooks 'post-load-hook)
