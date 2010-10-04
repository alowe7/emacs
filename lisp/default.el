(put 'default 'rcsid 
 "$Id$")

(require 'assoc-helpers)

(defvar post-load-hook nil "hook to run after initialization is complete")

(modify-syntax-entry ?- "w")

(setq list-directory-verbose-switches "-alt")

(setq horizontal-scroll-delta 20)

(fset 'html-mode 'sgml-mode)

;; sort in order of decreasing frequency

(defun add-auto-mode (extension mode)
  "add EXTENSION as a filetype for MODE to `auto-mode-alist'
items get added at the head so in effect override any previous definition.
"

  (setq auto-mode-alist 
	(nconc (list (cons extension mode))  auto-mode-alist)
	)
  )

(mapcar '(lambda (x) (add-auto-mode (car x) (cdr x)))
	'(
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
	  ("\\.js$" . java-mode)
	  ("\\.pac$" . java-mode)
	  ("\\.jsp$" . html-mode)
	  ("\\.jws$" . html-mode)
	  ("\\.php$" . php-mode)
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
	  ("\\.opml$" . xml-mode)
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
	  ("\\.Z$" . uncompress-while-visiting)
	  ("\\.gz$" . uncompress-while-visiting)
	  ("\\.tar$" . tar-mode)
  ;			("\\.lst$" . list-mode)
	  ("\\.tex$" . TeX-mode)
	  ("\\.scm$" . scheme-mode) 
	  ("\\.lisp$" . lisp-mode)
	  ("\\.f$" . fortran-mode)
	  ("\\.mss$" . scribe-mode)
	  ("\\.css$" . css-mode)
	  )
	)

;;(add-auto-mode "\\.sh$" 'shell-mode)
(setq next-line-add-newlines nil)
(setq c-tab-always-indent nil)

; limits

(setq kill-ring-max 10000
      message-log-max 10000
      list-command-history-max 10000)

(add-hook 'find-file-hooks 'auto-auto-mode)

(add-hook 'write-file-hooks 'time-stamp)

(add-hook 'emacs-lisp-mode-hook '(lambda ()
				   (modify-syntax-entry ?- "w")
				   (modify-syntax-entry ?* "w")
  ;				   (set-tabs 2)
				   (setq comment-column 2)
				   (font-lock-mode)
				   ) 
	  t)

(add-hook 'sh-mode-hook '(lambda () (use-local-map nil)))
(add-hook 'css-mode-hook '(lambda () (font-lock-mode)))

(autoload '/* "long-comment")

; apply message to args iff non-nil
(defun message* (&rest args)
  (and args (apply 'message args)))

(defun bgets () 
  (chomp (thing-at-point (quote line)))
  )

(run-hooks 'post-load-hook)

;; default implementation.  custom configs can override
(fset 'host-ok 'identity)

(provide 'default)
