; default-lib is stuff that ought to be pure
;(load-library "default-lib")

(require 'config) ; this feature should not be required for anything up to this point

; when is this not true?
(setq user-full-name "Andrew J. Lowe")

(load (uname) t t)		; load os-specific info

; emacs specific initialization
; epoch, lucid, and xemacs variants caused problems once upon a time, ...

(and (boundp 'emacs-major-version)
     (load (concat "Emacs" emacs-major-version) t t))

(or (fboundp 'set-tabs)
    (defun set-tabs (w) (interactive "ntab width: ") (setq tab-width w)))


(load "keys" nil t) ;key bindings
(load "autoloads" nil t) ;automatically generated now

(modify-syntax-entry ?- "w")

(defvar list-directory-verbose-switches	"-alt")

(defvar horizontal-scroll-delta 20)


;;; todo: c++ mode for .C files?
(setq auto-mode-alist '(
			("\\.l$" . c++-mode) ; lex
			("\\.java$" . java-mode)
			("\\.pl$" . perl-mode)
			("\\.pm$" . perl-mode)
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


(setq explicit-bash-args '("-login" "-i"))

(modify-syntax-entry ?* "w" emacs-lisp-mode-syntax-table)

(add-hook 'write-file-hooks 'time-stamp)

(add-hook 'emacs-lisp-mode-hook '(lambda ()
				   (modify-syntax-entry ?- "w")
				   (modify-syntax-entry ?* "w")
;				   (set-tabs 2)
				   (setq comment-column 2)
				   ) 
	  t)


(defun line-as-region ()
	(let ((x (point)) y z)
	  (beginning-of-line)
	  (setq y (point))
	  (end-of-line)
	  (setq z (point))
	  (goto-char x)
	  (list y z)))


(defun highlight-next-line (arg)
  (interactive "p")

  (apply 'hilit-unhighlight-region
	 (nconc 
	  (line-as-region)
	  (list
	   t))
	 )


  (next-line arg)

  (apply 'hilit-highlight-region
	 (nconc 
	  (line-as-region)
	  (list
	   '(("." nil highlight))
	   t))
	 )

  )

(defun highlight-previous-line (arg)
  (interactive "p")

  (apply 'hilit-unhighlight-region
	 (nconc 
	  (line-as-region)
	  (list
	   t))
	 )


  (previous-line arg)

  (apply 'hilit-highlight-region
	 (nconc 
	  (line-as-region)
	  (list
	   '(("." nil highlight))
	   t))
	 )

  )

(add-hook 'logview-mode-hook
	  `(lambda () 
	     (define-key logview-mode-map "" 'highlight-next-line)
	     (define-key logview-mode-map "" 'highlight-previous-line)
	     )
	  )

(defun unhighlight-buffer () (interactive) 
  (hilit-unhighlight-region (point-min) (point-max) t))

;(unhighlight-buffer)
;(load "~/emacs/play/tasks.el" nil t)

(add-hook 'emacs-startup-hook 
	  '(lambda () 
	     (find-file "~/todo")
	     (end-of-buffer)))


;; optional host-specific overrides
(load (hostname) t t t)

; load display-specific init if any

;; should run after hooks
;; this is sometimes useful in X if DISPLAY is not localhost
;(load (displayhost) t t)
