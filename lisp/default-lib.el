;; this lib should contain functions that would go in pure code if possible.

; (require 'cl) ; this should definitely be pure.

(defun loadq (x)
  (and x (load x nil t nil)))

(defun loads (x)
  (load-library (symbol-name x)))

(defun inv (v) 
  "insert evaluated lisp expression" 
  (interactive "XLisp Expression: ")
  (insert v))


(defun insert-date () (interactive) (insert (eval-process "date")))

;;; overloaded functions

(defun insert-eval-environment-variable (v)
  "insert value of specified environment VARIABLE"
  (interactive "sName of variable:")
  (insert (getenv v)))

(defvar search-last-string "" "\
Last string search for by a non-regexp search command.
This does not include direct calls to the primitive search functions,
and does not include searches that are aborted.")


(defun current-word-search-forward () 
  (interactive)
  (forward-word 1)
  (backward-word 1)
  ;; push ont search-ring for emacs19
  (push 
   (setq search-last-string
	 (buffer-substring (point) (progn (forward-word 1) (point))))
   search-ring)
  (or (search-forward search-last-string nil t)
      (message "\"%s\" not found" search-last-string))
  (backward-word 1))

(defun current-word-search-backward ()
  (interactive)
  (forward-word 1) 
  (setq search-last-string
	(buffer-substring (point) (progn (backward-word 1) 
					 (point))))
  (or (search-backward search-last-string nil t)
      (message "\"%s\" not found" search-last-string)))

(defun kill-pattern (pat &optional n)
  "delete all ocurrences of PAT in current buffer.
if optional arg N is specified deletes additional N subsequent chars also"
  (beginning-of-buffer)
  (while 
      (re-search-forward pat nil t) 
    (delete-region (match-beginning 0) (+ (match-end 0) (or n 0)))
    )
  )
                         
(defun fix-man-page ()
  (interactive)
  (save-excursion
    (kill-pattern "_") ; hack for roff underlining
    (kill-pattern ".")
    (kill-pattern "8")
    (kill-pattern "9")
    ))


(defun find-file-force-refresh ()
  (interactive)
  (let ((fn (buffer-file-name)))
    (kill-buffer (current-buffer))
    (find-file fn)
    ))



(defun pwd ()
  (interactive)
  (message default-directory))

(defun pwd-other-window ()
  (interactive)
  (save-excursion
    (other-window 1) 
    (message default-directory)
    (other-window -1) )
  )


(defun wrap () 
  "toggle line truncation."
  (interactive)
  (if truncate-lines (set-variable 'truncate-lines nil) 
    (set-variable 'truncate-lines t))
  )

(defun wrap! () 
  (interactive)
  (set-variable 'truncate-lines t)
  )


(defun scroll-down-1 ()
  (interactive)
  (scroll-down 1)
  (if (not (bobp)) (previous-line 1))
  )

(defun scroll-up-1 ()
  (interactive)
  (scroll-up 1)
  (if (not (eobp)) (next-line 1))
  )


(defun cd-other-window ()
  " change the current window's current directory to that of other window"
  (interactive)
  (save-excursion
    (other-window 1)
    (let ((z (pwd)))
      (other-window -1)
      (cd z))))

(defun wordness ()
  (interactive)
  (modify-syntax-entry ?/ "w" (syntax-table))
  (modify-syntax-entry ?_ "w" (syntax-table))
  (modify-syntax-entry ?- "w" (syntax-table))
  (modify-syntax-entry ?. "w" (syntax-table))
  (modify-syntax-entry ?: "w" (syntax-table))
  (modify-syntax-entry ?~ "w" (syntax-table))
  )

(defun fileness ()
  (interactive)
  (modify-syntax-entry ?/ "." (syntax-table))
  (modify-syntax-entry ?_ "." (syntax-table))
  (modify-syntax-entry ?- "." (syntax-table))
  (modify-syntax-entry ?. "." (syntax-table))
  (message "fileness")
  )


(defun set-tabs (n)
  "set variable tab-width to N"
  (interactive "ntab width: ")
  (set-variable (quote tab-width) n)
  )

(defun toggle-case-fold ()
  "shortcut to toggle case-fold-search (q.v.)"
  (interactive)
  (setq case-fold-search (not case-fold-search))
  (message "case-fold-search is %s" (if case-fold-search "on" "off"))
  )


(defun split-list (l p)
  "split environment list l at item p, if found.
 return list of lists l1, l2 "
  (interactive)

  (let ((len (length p)) (a l) (a1 nil) (a2 nil))
    (while a
      (if (and (string-match p (car a)) (= (match-end 0) len))
	  (progn (setq a2 (cdr a)) (setq a nil))
	(progn (setq a1 (append a1 (list (car a)))) (setq a (cdr a))))
      )
    (cons a1 a2)
    )
  )

(defun space-to (col &optional char)
  (interactive "ncolumn: ")
  (let ((ncols (- col (current-column))))
    (while (> ncols 0) (progn (insert (or char " ")) (setq ncols (1- ncols))))
    )
  )

(defun vn ()
  " suck people file into an edit buffer"
  (interactive)
  (find-file *people-database*)
  )


(defun y-or-n-*-p (prompt &optional chars &rest args)
  "display PROMPT and read characters.
returns t for y, nil for n ?q for q, else loop
with optional string CHARS, also matches specified characters.
"
  (interactive)
  (catch 'done
    (while t
      (apply 'message (cons prompt args))
      (let ((c (read-char)) x)
	(cond 
	 ((char-equal c ?y) (throw 'done t))
	 ((char-equal c ?n) (throw 'done nil))
	 (chars
	  (dotimes (x (length chars)) 
	    (let ((c2 (aref chars x))) 
	      (and (char-equal c c2) (throw 'done c2)))))
	 (t (setq prompt (format "%s (y %s to continue, n for next): " prompt 
				 (string* chars "")
				 )))
	 )
	)
      )
    )
  )

(defun y-or-n-q-p (prompt &optional chars &rest args)
  "display PROMPT and read characters.
returns t for y, nil for n ?q for q, else loop
with optional string CHARS, also matches specified characters.
"
  (interactive)
  (catch 'done
    (while t
      (apply 'message (cons prompt args))
      (let ((c (read-char)) x)
	(cond 
	 ((char-equal c ?q) (throw 'done ?q))
	 ((char-equal c ?y) (throw 'done t))
	 ((char-equal c ?n) (throw 'done nil))
	 (chars
	  (dotimes (x (length chars)) 
	    (let ((c2 (aref chars x))) 
	      (and (char-equal c c2) (throw 'done c2)))))
	 (t (setq prompt (format "%s (y to continue, n for next, q to quit loop): " prompt)))
	 )
	)
      )
    )
  )

(defun touch (fn)
  "touch filename"
  (call-process "touch" nil 0 nil fn)
  t
  )


(defun findcmd (cmd)
  "visit file containing COMMAND"
  (interactive "Ccommand: ")
  (catch 'done
    (let ((p load-path)
	  q)
      (while p
	(if (file-exists-p (setq q (concat (car p) "/TAGS"))) (throw 'done q)
	  (setq p (cdr p))))))
  )




;; finds first occurrence of f along p
(defun wis (p f) (interactive)
  (let ((f (concat (car p) "/" f)))
    (if (file-exists-p f) f (wis (cdr p) f))))

;;;

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


(defun reverse-lines ()
  (interactive)
  (beginning-of-buffer)
  (let (x)
    (while (not (eobp))
      (push (bgets) x)
      (kill-line 1)
      )
    (while x
      (insert (pop x))
      (insert "\n"))
    ))




(defun buffer-process (&optional ib)
  "return process associated with BUFFER, if any.
   default to current buffer."
  (interactive "b")
  (let* ((b (cond ((and (stringp ib) (> (length ib) 0)) (get-buffer ib))
		  (t (current-buffer))))
	 (v (catch 'found
	      (mapcar '(lambda (x) (if (eq (process-buffer x) b) (throw 'found x))) (process-list)))))
    (and (atom v) v )
    )
  )



(defun get-real-buffer-list (arg)
  (let* ((rbl (buffer-list))
	 (bl (append (cdr rbl) (list (car rbl))))
	 bn val x)
    (dolist (x (if arg bl (reverse bl)))
      (setq bn (buffer-name x))
  ;skip killed buffers & those whose name begins with a space
      (and bn (> (length bn) 0) (not (eq ?  (aref bn 0))) (push x val)))
    val))

;;(setq x (get-real-buffer-list nil))


;; walk mru list of buffers

(defun collect-buffers (mode) 
  (let ((l (loop for x being the buffers
		 if (eq mode (progn (set-buffer x) major-mode))
		 collect x)))
    (and l (append (cdr l) (list (car l))))
    )
  )

(defun chmod (mode)
  "change mode on file associated with current buffer"
  (interactive "smode: ")
  (call-process "chmod" nil 0 nil mode (buffer-file-name)))


(defun debug-on-error () 
  "toggle state of debug-on-error variable"
  (interactive)
  (setq debug-on-error (not debug-on-error))
  (message "debug-on-error %s" (if debug-on-error "enabled" "disabled"))
  )


(defun eval-file (fn)
  (let ((b (get-file-buffer fn)))
    (if b (save-excursion
	    (set-buffer b )
	    (eval-current-buffer))
      (if (file-exists-p fn) (load fn t t t)))
    )
  )



(defun display-control-chars () 
  "toggle display of control chars"
  (interactive)
  (if (or (null ctl-arrow) (eq ctl-arrow t))
      (setq ctl-arrow 1)
    (setq ctl-arrow t)
    )
  )



(defun isearch-region () 
  (interactive)
  (setq search-last-string (buffer-substring (point) (mark)))
  (call-interactively 'isearch-forward t)
  )



(defun add-auto-mode (extension mode)
  (if (not (assoc extension auto-mode-alist))
      (let ((na (list (cons extension mode))))
	(append na (copy-alist auto-mode-alist)))))

(defun getenvp (which) 
  (interactive "sWhich: ")
  "like getenv, but returns nil if not set" 
  (let ((v (getenv which)))
    (and (> (length v) 0) v)
    )
  )

(defun squeeze (begin end)
  (interactive "r")

  (let ((s
	 (trim-blank-lines
	  (trim-trailing-white-space
	   (trim-leading-white-space
	    (trim-blank-lines
	     (buffer-substring begin end)))))))

    (kill-region begin end)
    (insert s)
    (call-process-region begin (+ begin (length s))  "tr" t t nil "-s" "\" 	\"")
    ))

(defun list-mode-buffers (mode)
  (interactive "Smode: ")
  "returns a list of buffers with specified MODE
when called interactively, displays a pretty list"
  (let ((l 
	 (loop
	  for x being the buffers 
	  if (eq (progn (set-buffer x) major-mode) mode) 
	  collect x)))
    (if (interactive-p) 
	(let ((b (zap-buffer "*Buffer List*")))
	  (set-buffer b)
	  (dolist (x l) (insert (buffer-name x) "\n"))
	  (pop-to-buffer b))
      l)))

(defun remq (a l)
  "remove any associations for A in alist L "
  (loop 
   for z in l
   if (not (equal (car z) a))
   collect z))

(defun rremq (v l)
  "remove any associations whose value is for V from alist L "
  (loop 
   for z in l
   if (not (equal (cdr z) v))
   collect z))

(defun diff-recovered-file ()
  (interactive)
  (let ((f (format "/tmp/%s" (gensym))))
    (write-region (point-min) (point-max) f)
    (shell-command (concat "diff " f " " (buffer-file-name)))
    (delete-file f)
    )
  )

(defvar *last-awk-script* nil)

(defun awk (script) 
  (interactive (list (read-string (format "script (%s): " *last-awk-script*))))

  "run awk on the current region, prompting for script.  this works
around a bug in the win32 implementation of awk that doesn't like to
see \' or \" in the script, but it is generally useful, anyway."

  (let ((fn (mktemp "__awktmp")))

    (if (<= (length script) 0)
	(setq script (or *last-awk-script* (read-string "script: "))))
    (setq *last-awk-script* script)

    (write-region script nil fn nil 0) ; weird feature of write region

    (shell-command-on-region (point) (mark) (format "awk -f %s" fn) "*awk*")
  ;		(delete-file fn)
    )
  )


(defun strrspn (s p)
  (loop
   for x downfrom (length s) to 1
   if (not (in (elt s (1- x)) p)) return (substring s 0 x)
   finally return ""
   )
  )

; these do the same thing, except in returns the position like strchr
(defun in (c s) (string-match (format "%c" c) s))
(defun vmember (c s) 
  (loop for sc across s thereis  (= c sc)))


(defun find-in-buffers (s &optional buffer-list)
  "find string s in any buffer.  returns a list of matching buffers"
  (loop for x being the buffers 
	if (save-excursion
	     (set-buffer x)
	     (goto-char (point-min))
	     (search-forward s nil t))
	collect x))

(defun filemodtime (f)
  (elt (file-attributes f) 5))
(defun fileacctime (f)
  (elt (file-attributes f) 4))

(defun compare-filetime (a b)
  "compare file times A and B.
 returns -1 if A preceeds B, 0 if they're equal, 1 otherwise "
  (cond ((null (or a b)) 0)
	((null a) -1)
	((null b) 1)
	((< (car a) (car b)) -1)
	((> (car a) (car b)) 1)
	((< (cadr a) (cadr b)) -1)
	((> (cadr a) (cadr b)) 1)
	(t 0)))

(defmacro ifp (ifp-s ifp-a ifp-b)
  "if EXPRESSION is a non-empty string eval A else eval B" 
  (if (and ifp-s (> (length (eval ifp-s)) 0)) ifp-a ifp-b))

(autoload '/* "long-comment")

(defun setqp (a b)
  (and 
   (boundp a)
   (set a b)
   ))

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

; todo: go back and fix all refs
(defmacro string* (**s** &optional **default**)
  "evaluates to STRING if non-null and nonzero length, else DEFAULT.
 arguments are evaluated only once"
  (let ((*s* (eval **s**))) (or (and (sequencep *s*) (> (length *s*) 0) *s*) (eval **default**))))

(defmacro number* (**n** &optional **default**)
  "evaluates to NUMBER if a numberp.
  if NUMBER is a string representation of a numberp, then reads the string value.
  otherwise returns optional DEFAULT.
 arguments are evaluated only once"
  (let ((*n* (eval **n**))) (cond ((numberp *n*) *n*)
				  ((string* *n*) (car (read-from-string *n*)))
				  (t (eval **default**)))))

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
    (if (string* sym) sym default))
  )


(provide 'default-lib)
