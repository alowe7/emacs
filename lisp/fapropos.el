(put 'fapropos 'rcsid 
 "$Id: fapropos.el,v 1.5 2000-10-03 16:50:27 cvs Exp $")
(require 'indicate)
(require 'oblists)
(require 'lwhence)
(provide 'fapropos)


(defvar fapropos-alist '((emacs-lisp-mode obarray)
			 (lisp-interaction-mode obarray)
			 (c++-mode c-obarray )
			 (html-mode c-obarray )
			 (shell-mode shell-obarray)))

(defun fapropos-mode ()
  (beginning-of-buffer)
  (help-mode)
  (set-buffer-modified-p nil)
  (setq truncate-lines t)
  )

(defun fapropos1 (pat default-array)
" return matches for PAT in ARRAY formatted as a single string"
  (let ((val))
    (dolist (a	default-array)
      (if (arrayp  (if (symbolp a) (eval a) a))
	  (dotimes (x (length (if (symbolp a) (eval a) a))) 
	    (let ((s (format "%s" (aref (if (symbolp a) (eval a) a) x))))
	      (if (string-match pat s) (setq val (concat val s "\n")))))
	(dolist (x (if (symbolp a) (eval a) a))
	  (if (string-match pat (car x)) (setq val (concat val (car x) "\n"))))
	)
      )
    val))

(defun fapropos4-helper ()
  (nconc (list
	  (read-string "pattern: ")
	  (eval (intern (string* (read-string "obarray: ")))))
	 (let (x) (loop
		   while (string* (setq x (read-string "pattern: ")))
		   collect x)))
  )

(defun fapropos4 (pat array &rest args)
  "return matches for PAT in ARRAY"
  (interactive (fapropos4-helper)) ;; if specified remaining args are joined

  (let ((array (or array obarray)))
    (loop 
     for x across array
     if (and (symbolp x) (string-match pat (symbol-name x))
	     (or (not args)
		 (loop for y in args
		       unless (string-match y (symbol-name x)) return nil
		       finally return t)
		 )
	     )
     collect x)
    )
  )


(defvar obstack '(obarray))

(defun push-obstack (x)
  (interactive (list (completing-read "obarray: " '(("obarray") ("c-obarray")) nil t)))
  (setq obstack (eval (intern x))))


(defun fapropos (pat &rest array)
  "a version of apropos that actually works.
default behavior is to search all obarrays in obstack for REGEXP.
interactively with prefix arg, searches emacs obarray.
called from a program, optional args are:
REGEXP OBARRAY
if interactive and REGEXP is not given, it is prompted for.
else if REGEXP is not given, (indicated-word) is used
fapropos will only find symbols which have already been interned
"
  (interactive (op-arg  "fapropos (%s): "))
  (let* ((default-array 
	   (or array (cdr (assoc major-mode fapropos-alist))
	       obstack))
	 (b (zap-buffer "*Help*"))
	 (w (get-buffer-window b))
	 (val (and pat (> (length pat) 0) (fapropos1 pat default-array)))
	 )

    (if val
	(progn
	  (setq obstack default-array)
	  (or (and w (select-window w))
	      (switch-to-buffer-other-window b))
	  (insert val)
	  (beginning-of-buffer)
	  )
      (message "no matches for %s in %s" pat (car default-array))
      )
    )
  )

(defun atoms-like (y)
  (loop
   for x being the symbols of obarray 
   if (and (or (boundp x) (functionp x)) (string-match y (format "%s" x)))
   collect x))


(defun fapropos2 (x) (interactive "sstring: ")
  (loop
   initially (zap-buffer "*Help*")
   finally (progn (pop-to-buffer "*Help*") (beginning-of-buffer))
   for y in (atoms-like x) do
   (let ((s (format "%s" y))) 
     (insert s "\t" 
	     (or (if (functionp y)
		     (documentation y)
		   (documentation-property y 'variable-documentation)) "") "\n"))))



(defun symbols-like (s &optional as-strings)
  "list variables with names matching regexp PAT"
  (interactive "sString: ")
  (let ((v (if (or as-strings (interactive-p))
	       (loop for sym being the symbols
		     with name = nil
		     when (or (boundp sym) (fboundp sym))
		     when (string-match s (setq name (symbol-name sym)))
		     collect name)
	     (loop for sym being the symbols
		   when (or (boundp sym) (fboundp sym))
		   when (string-match s (symbol-name sym))
		   collect sym)
	     )))
    (if (interactive-p)
	(let ((standard-output (get-buffer-create "*vars*")))
	  (display-completion-list v)
	  (pop-to-buffer standard-output)
	  (beginning-of-buffer)
	  )
      v)
    )
  )

; (add-hook 'completion-setup-hook 'apropos-completion-setup-function)

; (defun apropos-completion-setup-function ()
;  (local-set-key (vector (quote down-mouse-1))
; 								'(lambda (e) (interactive) (debug))))

(defun fapropos3 (s) (interactive "sString: ")
  (let* ((ss (completing-read "Complete: " 
			      (loop for x in (symbols-like s t)
				    collect
				    (list x)) nil t))
	 (ssi (intern ss)))

    (cond ((fboundp ssi) 
	   (describe-function ssi))
	  ((boundp ssi)
	   (describe-variable ssi))
	  )
    )
  )


(defun vars-with (s)
  "list variables where value is a string matching regexp PAT"
  (interactive "sString: ")
  (let ((v (loop for sym being the symbols
		 when (boundp sym)
		 when (stringp (eval sym))
		 when (string-match s (eval sym))
  ; specifically exclude target
		 unless (string-match "^s" (symbol-name sym) )
		 collect sym)))
    (if (interactive-p)
	(let* ((b (zap-buffer "*vars*"))
	       (standard-output b))
	  (loop for x in v
		do 
		(insert "\n" (symbol-name x) "\t" 
			(string* (lwhence x) "") "\n" "\t")
		(pp (eval x))
		(insert "\n")
		)

	  (pop-to-buffer b)
	  (fapropos-mode)
	  ))
    v)
  )




(defun vars-like-with (name pat)
  "list variables where symbol-name matches regexp NAME, 
and value is a string matching regexp PAT"
  (interactive "sname like: \nsvalue like: ")
  (let ((v (loop for sym being the symbols
		 when (boundp sym)
		 when (stringp (eval sym))
		 when (string-match name (symbol-name sym))
		 when (string-match pat (eval sym))

  ; specifically exclude target, because, of course the symbol 'name
  ; will match while we're in this loop...
		 unless (string-match "^name$" (symbol-name sym) )

		 collect sym)))

    (if (interactive-p)
	(let* ((b (zap-buffer "*vars*"))
	       (standard-output b))
	  (loop for x in v
		do 
		(insert "\n" (symbol-name x) "\t" 
			(string* (lwhence x) "") "\n" "\t")
		(pp (eval x))
		(insert "\n")

		)
	  (pop-to-buffer b)
	  (fapropos-mode)))
    v)
  )


(defun vars-like-with-expr (pat l)
  "list variables where name is a string matching regexp PAT, 
and value satisfies lambda expression of one arg L.
L takes a single arg"
  (interactive "ssymbol names matching: \nxstring values matching (exprs ok):")
  (let ((v (loop for sym being the symbols
		 when (boundp sym)
		 when (string-match pat (symbol-name sym))
		 when (funcall l (eval sym))
		 collect sym)))
    (if (interactive-p)
	(let ((m ""))
	  (loop for x in v
		do (setq m (concat m (symbol-name x) " ")))
	  (message m)))
    v)
  )


(defun function-help-string (fn &optional more)  
  "displays the help string for FUNCTION.
with optional arg MORE, appends its value to the help string,
unless it is already there
"
  (let* ((f (symbol-function fn)) 
	 (s (caddr f)))
    (and (stringp s) 
	 (or (and (null more) s)
	     (and (null (string-match more s))
		  (rplaca (cddr f) (concat s more)))))))
; e.g. 
; (function-help-string  'cscope-mode "  t to toggle tpath searching
;  d to debug tpath searching
;")
