(put 'default-lib 'rcsid 
 "$Id: default-lib.el,v 1.8 2001-07-10 08:17:17 cvs Exp $")

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

(defmacro read-from-string* (**s** &optional **default**)
  "evaluates to intern STRING if non-null and nonzero length, else DEFAULT.
 arguments are evaluated only once"
  (let ((*s* (eval **s**))) (if (and (sequencep *s*) (> (length *s*) 0)) (car (read-from-string *s*))
				     (eval **default**))))

(defmacro read-from-env (**v** &optional **default**)
  "evaluates to intern STRING if non-null and nonzero length, else DEFAULT.
 arguments are evaluated only once"
  (let ((*s* (getenv (eval **v**)))) (if (and (sequencep *s*) (> (length *s*) 0)) (car (read-from-string *s*))
				     (eval **default**))))


(defun env (v)
  "insert value of environment variable V"
  (interactive "svar: ")
  (insert (getenv v)))
