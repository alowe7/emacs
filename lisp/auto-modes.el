(put 'auto-modes 'rcsid
 "$Id$")

(defun add-auto-mode (extension mode)
  "add EXTENSION as a filetype for MODE to `auto-mode-alist'
items get added at the head so in effect override any previous definition.
"

  (let ((a (assoc extension auto-mode-alist)))

    (cond
     (a
      (setcdr a mode))
     (t
      (setq auto-mode-alist 
	    (nconc auto-mode-alist (list (cons extension mode))  )
	    )
      )
     )
    )
  )

(mapc (lambda (x) (add-auto-mode (car x) (cdr x)))
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
	  ("\\.css$" . css-mode)
	  ("\\.cs$" . cs-mode)
	  )
	)

(defvar guess-auto-mode-alist
  '(
    ("perl" . perl-mode)
    )
  "try to deduce mode for scripts in files without filename extension, beginning with shbang construct"
  )

(defun guess-auto-mode ()
  (if (and (eq major-mode 'fundamental-mode) (> (point-max) 3)
	   (save-excursion (goto-char (point-min)) (and (string-match "^#!\\(.*\\)$" (thing-at-point 'line)))))

      (let* ((command-line (buffer-substring (1+ (match-beginning 1))  (1+ (match-end 1))))
	     (command (substring command-line (or (string-match "[^ ]+$" command-line) 0))
		      )
  ; for some reason this loop didn't behave correctly when compiled
  ; 	     (mode (loop for x in guess-auto-mode-alist when (string-match (car x) command) return (cdr x)))
  ; and this is just stupid
  ;	     (mode (catch 'ret (mapcar (lambda (x) (if (string-match (car x) command) (throw 'ret (cdr x))))  guess-auto-mode-alist)))
	     (mode (cdr (assoc command guess-auto-mode-alist))))

	(when (and mode (fboundp mode))
	  (condition-case err
	      (funcall mode)
	    (error (debug)))
	  )
	)
    )
  )
(add-hook 'find-file-hooks 'guess-auto-mode)

;;(add-auto-mode "\\.sh$" 'shell-mode)

(provide 'auto-modes)
