(put 'default 'rcsid 
 "$Id: default.el,v 1.43 2004-10-01 23:07:54 cvs Exp $")

(defvar post-load-hook nil "hook to run after initialization is complete")

(load "keys" nil t) ;key bindings

(modify-syntax-entry ?- "w")

(setq list-directory-verbose-switches "-alt")

(setq horizontal-scroll-delta 20)

(fset 'html-mode 'sgml-mode)

(autoload 'css-mode "css-mode")

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
			("\\.js$" . java-mode)
;			("\\.jsp$" . java-mode)
			("\\.php$" . perl-mode)
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
			("\\.css\\'" . css-mode)
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
				   (font-lock-mode)
				   ) 
	  t)

(add-hook 'sh-mode-hook '(lambda () (use-local-map nil)))
(add-hook 'css-mode-hook '(lambda () (font-lock-mode)))

;; from default-lib

(defun buffer-exists-p (bname)
  " return buffer with specified NAME or nil"
  (interactive "Bbuffer name:") 
  (let ((bl (buffer-list)))
    (while (and bl  (not (string-equal bname  (buffer-name (car bl))))
		(setq bl (cdr bl))))
    (and bl (car bl))
    ))


(defun assocd (a l d)
  " like assoc, but return d if a is not on l"
  (let ((v (cdr (assoc a l))))
    (or v d)))

(defun add-auto-mode (extension mode)
  (if (not (assoc extension auto-mode-alist))
      (let ((na (list (cons extension mode))))
	(append na (copy-alist auto-mode-alist)))))


(defmacro ifp (ifp-s ifp-a ifp-b)
  "if EXPRESSION is a non-empty string eval A else eval B" 
  (if (and ifp-s (> (length (eval ifp-s)) 0)) ifp-a ifp-b))

(autoload '/* "long-comment")

(defmacro condlet (expr &rest body)
  "like:
 (let ((*v* (eval EXPR))) (cond BODY))
 evals EXPR only once, bound to local var *v*"
  (let ((*v* (eval expr))) (eval (cons 'cond body)))
  )

(defmacro directory* (**f** &optional **sub**)
  "canonicalizes f with optional subdir"
  (let ((*f* (eval **f**))
	(*sub* (eval **sub**)))
    (concat *f* (if (not (string= (substring *f* -1) "/")) "/") *sub*))
  )

; apply message to args iff non-nil
(defun message* (&rest args)
  (and args (apply 'message args)))


(defmacro complete*  (prompt &optional pat default)
  "read a symbol with completion.
 prompting with PROMPT, complete in obarry for symbols matching regexp PAT,
 default to DEFAULT"  
  (let ((sym (completing-read  
	      (format prompt (eval default))
	      obarray
	      (if pat (lambda (x) (string-match pat (format "%s" x)))))))
    (if (and (sequencep sym) (> (length sym) 0)) sym default))
  )

(defun region ()
  (buffer-substring (region-beginning) (region-end))
  )

(defun modify-alist (x y z)
  (set x (loop for w in (eval x) collect 
	       (if (eq (car w) y) (cons y z) w))
       )
  )

(defun add-association (mapping list &optional clobber)
  "add an assoc MAPPING to a-list LIST.
clobber an existing mapping if optional CLOBBER is nonnil
"
  (let ((l (eval list)))
    (cond ((not (assoc (car mapping) l))
	   (push mapping l))
	  (clobber
	   (setq l (remove* mapping l :test '(lambda (x y)     
					       (equal (car x) (car y)))))
	   (push mapping l))
	  )
    (set list l)
    )
  )
; (setq x '((a 1) (b 2) (c 3)))
; (add-association '(d 4) 'x t)


(defun replace-in-string (from to str)
  "replace occurrences of REGEXP with TO in  STRING" 
  (if (string= from "^")
      (concat to (replace-in-string "
" (concat "
" to) str)) 
    (let (new-str
	  (sp 0)
	  )
      (while (string-match from str sp)
	(setq new-str (concat new-str (substring str sp (match-beginning 0)) to))
	(setq sp (match-end 0)))
      (setq new-str (concat new-str (substring str sp)))
      new-str))
  )

(defun bgets ()
  "do gets on current line from buffer. return as string"
  (let ((x (point)) y z)
    (beginning-of-line)
    (setq y (point))
    (end-of-line)
    (setq z (point))
    (goto-char x)
    (buffer-substring y z)
    )
  )


;; xxx there's an internal fn to do this..
;; modify indicate fns to use this & take optional string as arg
(defvar end-of-word nil)
(defvar *wordchars* "[ 	]*[^ 	(,;/\=]+[ 	(,;/\=]?" "pattern to match words")

(defun string-to-word (s &optional n)
  " return NTH word in string
 default is n=0 (first word)
if n > # words in string, returns last word.
if n < 0 counts from end of string
"
  (trim-white-space
   (catch 'done
     (let ((z nil) (m (or n 0)))
       (while (string-match *wordchars* s)
	 (let ((x (substring s (match-beginning 0) (setq end-of-word (match-end 0)))))
	   (if (= m 0) (throw 'done x))
	   (push x z)
	   (setq m (1- m))
	   (setq s  (substring s (match-end 0) (length s)))
	   )
	 )
  ;       (read-string (format " (%d: %s)" (min (1- (length z)) n) (nth  z)))
       (throw 'done 
	      (if (< m 0) (nth m z) 
		(nth (min (1- (length z)) m) (reverse z))))
       )
     )
   )
  )

(defun first (n l)
  "return a list consisting of the first N elements of LIST see `last'"
  (if (< 0 n) (last l (1- (- n)))
    (let* ((l l))
      (rplacd (nthcdr (1- n) l) nil)
      l)
    )
  )

; (first 3 (split (chomp (x-query "select tm from journal order by tm")) "
; "))

; (last 3 (split (chomp (x-query "select tm from journal order by tm")) "
; "))




(run-hooks 'post-load-hook)

;; (defadvice load (around 
;; 		 hook-load
;; 		 first 
;; 		 activate)
;; (read-string (format "load %s" (ad-get-arg 0)))
;;     ad-do-it
;; (read-string (format "after load %s" (ad-get-arg 0)))
;; )
;; (defadvice require (around 
;; 		 hook-load
;; 		 first 
;; 		 activate)
;; (read-string (format "require %s" (ad-get-arg 0)))
;;     ad-do-it
;; )

;; (defadvice  command-line (around 
;; 		 hook-command-line
;; 		 first 
;; 		 activate)
;; (debug)
;;     ad-do-it
;; (debug)
;; )
;    (add-hook 'before-init-hook 'debug)
; (add-hook 'after-init-hook 'debug)
; (debug-on-entry 'w32-add-charset-info)
; (add-hook 'term-setup-hook 'debug)
; (add-hook 'window-setup-hook 'debug)

;; default implementation.  custom configs can override
(fset 'host-ok 'identity)


