(defconst rcs-id "$Id: indicate.el,v 1.2 2000-07-30 21:07:46 andy Exp $")
(provide 'indicate)

;;
;; returns the word before point.
;; use modify-syntax-entry to change the definition of a "word"
;; 

;; alternate way to push/pop syntax class:
;; (comma-syntax
;;  (prog1 
;; 		 (char-syntax ?,)
;; 	 (modify-syntax-entry ?, "w")
;; 	 (indicated-word)
;; 	 (modify-syntax-entry ?, comma-syntax)
;; 	 ))
;; 

(defvar *indicated-word-region* nil 
  "holds region containing indicated-word.  see (indicated-word-region)")

(defun indicated-word (&optional include-chars from to)
  "evaluates to word indicated by cursor
   if string  INCLUDE-CHARS is specified, 
temporarily change the syntax entry for each char in the string to \"w\"
in the current buffer
" 
  (interactive)
  (let ((syntax-ref '(
		      (0 " "  "whitespace")
		      (1 "."  "punctuation")
		      (2 "w"   "word")
		      (3 "_"   "symbol")
		      (4 "("   "open parenthesis")
		      (5 ")"   "close parenthesis")
		      (6 "\'"  "expression prefix")
		      (7 "\""  "string quote")
		      (8 "$"   "paired delimiter")
		      (9  "\\" "escape")
		      (10 "/"  "character quote")
		      (11 "<"  "comment-start")
		      (12 ">"  "comment-end")))
	syntax-chars w i x)

    (if (and (syntax-table) include-chars)
	(dotimes (i (length include-chars))
	  (let ((char (aref include-chars i)))
	    (push (cons char (aref (syntax-table) char)) syntax-chars)
	    (modify-syntax-entry char "w" (syntax-table)))
	  )
      )

    (save-restriction 
      (narrow-to-region (or from (point-min)) (or to (point-max)))
      (setq *indicated-word-region* (indicated-word-region))
      (setq w
	    (apply 'buffer-substring *indicated-word-region*)
	    )
      )

    (dolist (x syntax-chars)
      (modify-syntax-entry (car x)
			   (cadr (assoc (cadr x) syntax-ref))
			   (syntax-table)))
    (if (interactive-p) (message w) w))
  )


(defun indicated-word-region ()
  "returns region bounding word under cursor"
  (interactive)
  (save-excursion

    (if (and (not (eolp)) 
	     (not (looking-at "[ 	(,;/]")))
	(forward-word 1))
    (if (not (bolp))
	(backward-word 1))
    (list (point) 
	  (progn
	    (forward-word 1)
	    (point)))
    )
  )

(defun op-arg (prompt &rest args)
  "acquire an argument using prompt.  default to indicated word.
prompt may have %s format specifications to show that
indicated-word is the default. remaining args are applied to prompt"
  (list
   (let ((w (read-string (apply 'format (append (list prompt (indicated-word)) args)))))
     (or (and (> (length w) 0)  w) (indicated-word))
     ))
  )

(defun find-indicated-file () 
  "reads in filename indicated by cursor"
  (interactive)
  (find-file (indicated-word))
  )

(defun word ()
  "displays (indicated-word)"
  (interactive)
  (message (indicated-word))
  )

;; interactively get a number from keyboard
(defun getcvt (v)
  (let ((e 1) (n 0))
    (while v (setq n (+ n (* (pop v) e)) e (* e 10)))
    n)
  )
;; todo : rewrite to use last-input-char rather than arg?
(defun getnumber (&optional arg)
  "arg is optional first digits as a list"
  (let ((v arg))
    (catch 'done
      (while t
	(progn
	  (setq x  (- (read-char) ?0))
	  (if (or (> x 9) (< x 0)) (throw 'done v))
	  (push x v)
	  (message "%d" (getcvt v)) ;echo prompt
	  )) )
    (getcvt v)
    )
  )


(defun indicated-line ()
  "returns current line"
  (interactive)
  (let (b e) 
    (save-excursion
      (beginning-of-line)
      (setq b (point))
      (end-of-line)
      (setq e (point))
      (buffer-substring b e))))


(defun find-indicated-file () 
  " point is on the name of a file.  find that file."
  (interactive)
  (find-file (indicated-word))
  )

(defmacro complete-indicated-word (prompt table &rest args)
  "complete indicated word using PROMPT and completing in TABLE.
prompt may contain formatting chars which as substituted via format
first with (indicated-word), then remaining ARGS.

a typical use might be with (interactive) :

  (interactive 
   (list (complete-indicated-word \"lookfor (%s): \" completion-table)))

"

  (let ((**i** (indicated-word)))
    (string* (completing-read
	      (apply 'format prompt
		     (cons **i**  args))
	      (eval table)) **i**)
    )
  )



(defun replace-indicated-word (expr) (interactive "xExpr: ")
  "replace indicated word with results of evaluating EXPR
EXPR may be a function of zero or one argument, the indicated-word"
  (let ((x (indicated-word)))
    (apply 'delete-region *indicated-word-region*)
    (if expr
	(condition-case err
	    (insert (funcall expr x))
	  (wrong-number-of-arguments
	   (unless (cadr (cadr err)) ; allow if expr takes no args
	     (caddr (cadr err))))
	  )
      )
    )
  )

; for example, to double a list of numbers:
;(while (not (eobp))
;  (replace-indicated-word '(lambda (x) 
;			     (format "%d" (* (read x) 2))))
;  (forward-line 1)
;  (beginning-of-line)
;
;  )
