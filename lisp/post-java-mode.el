(put 'post-java-mode 'rcsid
 "$Id: post-java-mode.el,v 1.3 2004-12-10 18:15:17 cvs Exp $")

(require 'proof-compat)

(define-key java-mode-map "\M-\C-a" `java-beginning-of-defun)
(define-key java-mode-map "\M-\C-e" `java-end-of-defun)

(defun java-beginning-of-defun (&optional arg)
  "Move point to beginning of current line.
With argument ARG not nil or 1, move forward ARG - 1 lines first.
If scan reaches end of buffer, stop there without error."
  (interactive "p")
  (or arg (setq arg 1))

  (if (< arg 0)
      (java-end-of-defun (- arg))

    (while (> arg 0)
      (beginning-of-line)

      ;; get out of comments
      (while (eq (buffer-syntactic-context) `block-comment)
	(forward-line 1))

      ;; get into the preceeding level-2 list
      (condition-case nil
	  (while (< (buffer-syntactic-context-depth) 2)
	    (down-list -1))
	(error nil))

      (let ((parse-sexp-ignore-comments t)
	    last butlast)
	(while (condition-case nil
		   (progn (backward-up-list 1)
			  t)
		 (error nil))
	  (setq butlast last
		last (point)))

	(cond (butlast
	       (goto-char butlast)
	       (backward-sexp)
	       (backward-sexp))
	      (last
	       (goto-char last)))
	(beginning-of-line))

      (setq arg (1- arg)))
    nil))

(defun java-end-of-defun (&optional arg)
  "Move forward to next end of defun.  With argument, do it that many times.
Negative argument -N means move back to Nth preceding end of defun.

An end of a defun occurs right after the close-parenthesis that matches
the open-parenthesis that starts a defun; see `beginning-of-defun`."
  (interactive "p")
  (or arg (setq arg 1))

  (if (< arg 0)
      (java-beginning-of-defun (- arg))

    (while (> arg 0)

      (down-list 1)			; move to somewhere in next defun-block
      (forward-line 1)			; don`t be on the first line

      (java-beginning-of-defun 1)	; find its head

      (down-list 1)	; into arg list
      (up-list 1)	; out and over arg list
      (down-list 1)	; into body
      (up-list 1)	; out and over body

      (setq arg (1- arg)))
    nil))



(defun parse-version-number (v)
  " convert a version number like \"5.30.9\" into the list of integegers '(5 30 9)"
  (mapcar 'read (split c-version "\\."))
  )

(let ((l (parse-version-number c-version)))
  (cond
   ((and (>= (car l) 5) (= (cadr l) 28)) 

    ;; XXX there's apparently a bug in the shipped version of this... see cc-engine.el
    (defun c-get-offset (langelem)
      ;; Get offset from LANGELEM which is a cons cell of the form:
      ;; (SYMBOL . RELPOS).  The symbol is matched against
      ;; c-offsets-alist and the offset found there is either returned,
      ;; or added to the indentation at RELPOS.  If RELPOS is nil, then
      ;; the offset is simply returned.
      (let* ((symbol (car langelem))
	     (relpos (cdr langelem))
	     (match  (assq symbol c-offsets-alist))
	     (offset (cdr-safe match)))
	(if match
	    (setq offset (c-evaluate-offset offset langelem symbol)))
	(if (vectorp offset)
	    offset
	  (+ (if (and relpos
		      (< relpos (c-point 'bol)))
		 (save-excursion
		   (goto-char relpos)
		   (if (looking-at c-comment-start-regexp)
		       (progn (goto-char (1- (match-end 0))) (current-column))
		     (current-column)))
	       0)
	     (or (and (numberp offset) offset)
		 (and (symbolp offset) (symbol-value offset))
		 0)))
	))

  ; (setq c-comment-start-regexp "[ 	]*/[/*\**]")
  ; (setq c-comment-start-regexp (concat "[ 	]*" c-Java-comment-start-regexp))

    ;; this one's hard to believe
    (defun c-guess-basic-syntax ()
      (save-excursion
	(save-restriction
	  (beginning-of-line)
	  (let* ((indent-point (point))
		 (case-fold-search nil)
		 (fullstate (c-parse-state))
		 (state fullstate)
		 literal containing-sexp char-before-ip char-after-ip lim
		 syntax placeholder c-in-literal-cache inswitch-p
		 tmpsymbol keyword injava-inher special-brace-list
		 ;; narrow out any enclosing class or extern "C" block
		 (inclass-p (c-narrow-out-enclosing-class state indent-point))
		 inenclosing-p)
	    ;; check for meta top-level enclosing constructs, possible
	    ;; extern language definitions, possibly (in C++) namespace
	    ;; definitions.
	    (save-excursion
	      (save-restriction
		(widen)
		(if (and inclass-p
			 (progn
			   (goto-char (aref inclass-p 0))
			   (looking-at (concat c-extra-toplevel-key "[^_]"))))
		    (let ((enclosing (match-string 1)))
		      (cond
		       ((string-equal enclosing "extern")
			(setq inenclosing-p 'extern))
		       ((string-equal enclosing "namespace")
			(setq inenclosing-p 'namespace))
		       )))))
	    ;; get the buffer position of the most nested opening brace,
	    ;; if there is one, and it hasn't been narrowed out
	    (save-excursion
	      (goto-char indent-point)
	      (skip-chars-forward " \t}")
	      (skip-chars-backward " \t")
	      (while (and state
			  (not containing-sexp))
		(setq containing-sexp (car state)
		      state (cdr state))
		(if (consp containing-sexp)
		    ;; if cdr == point, then containing sexp is the brace
		    ;; that opens the sexp we close
		    (if (= (cdr containing-sexp) (point))
			(setq containing-sexp (car containing-sexp))
		      ;; otherwise, ignore this element
		      (setq containing-sexp nil))
		  ;; ignore the bufpos if its been narrowed out by the
		  ;; containing class or does not contain the indent point
		  (if (or (<= containing-sexp (point-min))
			  (>= containing-sexp indent-point))
		      (setq containing-sexp nil)))))

	    ;; set the limit on the farthest back we need to search
	    (setq lim (or containing-sexp
			  (if (consp (car fullstate))
			      (cdr (car fullstate))
			    nil)
			  (point-min)))

	    ;; cache char before and after indent point, and move point to
	    ;; the most likely position to perform the majority of tests
	    (goto-char indent-point)
	    (skip-chars-forward " \t")
	    (setq char-after-ip (char-after))
	    (c-backward-syntactic-ws lim)
	    (setq char-before-ip (char-before))
	    (goto-char indent-point)
	    (skip-chars-forward " \t")

	    ;; are we in a literal?
	    (setq literal (c-in-literal lim))

	    ;; now figure out syntactic qualities of the current line
	    (cond
	     ;; CASE 1: in a string.
	     ((memq literal '(string))
	      (c-add-syntax 'string (c-point 'bopl)))
	     ;; CASE 2: in a C or C++ style comment.
	     ((memq literal '(c c++))
	      (c-add-syntax literal (car (c-literal-limits lim))))
	     ;; CASE 3: in a cpp preprocessor macro continuation.
	     ((and (eq literal 'pound)
		   (/= (save-excursion
			 (c-beginning-of-macro lim)
			 (setq placeholder (point)))
		       (c-point 'boi)))
	      (c-add-syntax 'cpp-macro-cont placeholder))
	     ;; CASE 4: In-expression statement.
	     ((and (or c-inexpr-class-key c-inexpr-block-key c-lambda-key)
		   (setq placeholder (c-looking-at-inexpr-block)))
	      (setq tmpsymbol (assq (car placeholder)
				    '((inexpr-class . class-open)
				      (inexpr-statement . block-open))))
	      (if tmpsymbol
		  ;; It's a statement block or an anonymous class.
		  (setq tmpsymbol (cdr tmpsymbol))
		;; It's a Pike lambda.  Check whether we are between the
		;; lambda keyword and the argument list or at the defun
		;; opener.
		(setq tmpsymbol (if (eq char-after-ip ?{)
				    'inline-open
				  'lambda-intro-cont)))
	      (goto-char (cdr placeholder))
	      (back-to-indentation)
	      (c-add-syntax tmpsymbol (point))
	      (unless (eq (point) (cdr placeholder))
		(c-add-syntax (car placeholder))))
	     ;; CASE 5: Line is at top level.
	     ((null containing-sexp)
	      (cond
	       ;; CASE 5A: we are looking at a defun, brace list, class,
	       ;; or inline-inclass method opening brace
	       ((setq special-brace-list
		      (or (and c-special-brace-lists
			       (c-looking-at-special-brace-list))
			  (eq char-after-ip ?{)))
		(cond
		 ;; CASE 5A.1: extern language or namespace construct
		 ((save-excursion
		    (goto-char indent-point)
		    (skip-chars-forward " \t")
		    (and (c-safe (progn (c-backward-sexp 2) t))
			 (looking-at (concat c-extra-toplevel-key "[^_]"))
			 (setq keyword (match-string 1)
			       placeholder (point))
			 (or (and (string-equal keyword "namespace")
				  (setq tmpsymbol 'namespace-open))
			     (and (string-equal keyword "extern")
				  (progn
				    (c-forward-sexp 1)
				    (c-forward-syntactic-ws)
				    (eq (char-after) ?\"))
				  (setq tmpsymbol 'extern-lang-open)))
			 ))
		  (goto-char placeholder)
		  (c-add-syntax tmpsymbol (c-point 'boi)))
		 ;; CASE 5A.2: we are looking at a class opening brace
		 ((save-excursion
		    (goto-char indent-point)
		    (skip-chars-forward " \t{")
		    ;; TBD: watch out! there could be a bogus
		    ;; c-state-cache in place when we get here.  we have
		    ;; to go through much chicanery to ignore the cache.
		    ;; But of course, there may not be!  BLECH!  BOGUS!
		    (let ((decl
			   (let ((c-state-cache nil))
			     (c-search-uplist-for-classkey (c-parse-state))
			     )))
		      (and decl
			   (setq placeholder (aref decl 0)))
		      ))
		  (c-add-syntax 'class-open placeholder))
		 ;; CASE 5A.3: brace list open
		 ((save-excursion
		    (c-beginning-of-statement-1 lim)
		    ;; c-b-o-s could have left us at point-min
		    (and (bobp)
			 (c-forward-syntactic-ws indent-point))
		    (if (looking-at "typedef[^_]")
			(progn (c-forward-sexp 1)
			       (c-forward-syntactic-ws indent-point)))
		    (setq placeholder (c-point 'boi))
		    (or (consp special-brace-list)
			(and (or (save-excursion
				   (goto-char indent-point)
				   (setq tmpsymbol nil)
				   (while (and (> (point) placeholder)
					       (= (c-backward-token-1 1 t) 0)
					       (/= (char-after) ?=))
				     (if (and (not tmpsymbol)
					      (looking-at "new\\>[^_]"))
					 (setq tmpsymbol 'topmost-intro-cont)))
				   (eq (char-after) ?=))
				 (looking-at "enum[ \t\n]+"))
			     (save-excursion
			       (while (and (< (point) indent-point)
					   (= (c-forward-token-1 1 t) 0)
					   (not (memq (char-after) '(?\; ?\()))))
			       (not (memq (char-after) '(?\; ?\()))
			       ))))
		  (if (and (c-major-mode-is 'java-mode)
			   (eq tmpsymbol 'topmost-intro-cont))
		      ;; We're in Java and have found that the open brace
		      ;; belongs to a "new Foo[]" initialization list,
		      ;; which means the brace list is part of an
		      ;; expression and not a top level definition.  We
		      ;; therefore treat it as any topmost continuation
		      ;; even though the semantically correct symbol still
		      ;; is brace-list-open, on the same grounds as in
		      ;; case 10B.2.
		      (progn
			(c-beginning-of-statement-1 lim)
			(c-forward-syntactic-ws)
			(c-add-syntax 'topmost-intro-cont (c-point 'boi)))
		    (c-add-syntax 'brace-list-open placeholder)))
		 ;; CASE 5A.4: inline defun open
		 ((and inclass-p (not inenclosing-p))
		  (c-add-syntax 'inline-open)
		  (c-add-class-syntax 'inclass inclass-p))
		 ;; CASE 5A.5: ordinary defun open
		 (t
		  (goto-char placeholder)
		  (if inclass-p
		      (c-add-syntax 'defun-open (c-point 'boi))
		    (c-add-syntax 'defun-open (c-point 'bol)))
		  )))
	       ;; CASE 5B: first K&R arg decl or member init
	       ((c-just-after-func-arglist-p)
		(cond
		 ;; CASE 5B.1: a member init
		 ((or (eq char-before-ip ?:)
		      (eq char-after-ip ?:))
		  ;; this line should be indented relative to the beginning
		  ;; of indentation for the topmost-intro line that contains
		  ;; the prototype's open paren
		  ;; TBD: is the following redundant?
		  (if (eq char-before-ip ?:)
		      (forward-char -1))
		  (c-backward-syntactic-ws lim)
		  ;; TBD: is the preceding redundant?
		  (if (eq (char-before) ?:)
		      (progn (forward-char -1)
			     (c-backward-syntactic-ws lim)))
		  (if (eq (char-before) ?\))
		      (c-backward-sexp 1))
		  (setq placeholder (point))
		  (save-excursion
		    (and (c-safe (c-backward-sexp 1) t)
			 (looking-at "throw[^_]")
			 (c-safe (c-backward-sexp 1) t)
			 (setq placeholder (point))))
		  (goto-char placeholder)
		  (c-add-syntax 'member-init-intro (c-point 'boi))
		  ;; we don't need to add any class offset since this
		  ;; should be relative to the ctor's indentation
		  )
		 ;; CASE 5B.2: K&R arg decl intro
		 (c-recognize-knr-p
		  (c-add-syntax 'knr-argdecl-intro (c-point 'boi))
		  (if inclass-p (c-add-class-syntax 'inclass inclass-p)))
		 ;; CASE 5B.3: Inside a member init list.
		 ((c-beginning-of-member-init-list lim)
		  (c-forward-syntactic-ws)
		  (c-add-syntax 'member-init-cont (point)))
		 ;; CASE 5B.4: Nether region after a C++ or Java func
		 ;; decl, which could include a `throws' declaration.
		 (t
		  (c-beginning-of-statement-1 lim)
		  (c-add-syntax 'func-decl-cont (c-point 'boi))
		  )))
	       ;; CASE 5C: inheritance line. could be first inheritance
	       ;; line, or continuation of a multiple inheritance
	       ((or (and c-baseclass-key
			 (progn
			   (when (eq char-after-ip ?,)
			     (skip-chars-forward " \t")
			     (forward-char))
			   (looking-at c-baseclass-key)))
		    (and (or (eq char-before-ip ?:)
			     ;; watch out for scope operator
			     (save-excursion
			       (and (eq char-after-ip ?:)
				    (c-safe (progn (forward-char 1) t))
				    (not (eq (char-after) ?:))
				    )))
			 (save-excursion
			   (c-backward-syntactic-ws lim)
			   (if (eq char-before-ip ?:)
			       (progn
				 (forward-char -1)
				 (c-backward-syntactic-ws lim)))
			   (back-to-indentation)
			   (looking-at c-class-key)))
		    ;; for Java
		    (and (c-major-mode-is 'java-mode)
			 (let ((fence (save-excursion
					(c-beginning-of-statement-1 lim)
					(point)))
			       cont done)
			   (save-excursion
			     (while (not done)
			       (cond ((looking-at c-Java-special-key)
				      (setq injava-inher (cons cont (point))
					    done t))
				     ((or (not (c-safe (c-forward-sexp -1) t))
					  (<= (point) fence))
				      (setq done t))
				     )
			       (setq cont t)))
			   injava-inher)
			 (not (c-crosses-statement-barrier-p (cdr injava-inher)
							     (point)))
			 ))
		(cond
		 ;; CASE 5C.1: non-hanging colon on an inher intro
		 ((eq char-after-ip ?:)
		  (c-backward-syntactic-ws lim)
		  (c-add-syntax 'inher-intro (c-point 'boi))
		  ;; don't add inclass symbol since relative point already
		  ;; contains any class offset
		  )
		 ;; CASE 5C.2: hanging colon on an inher intro
		 ((eq char-before-ip ?:)
		  (c-add-syntax 'inher-intro (c-point 'boi))
		  (if inclass-p (c-add-class-syntax 'inclass inclass-p)))
		 ;; CASE 5C.3: in a Java implements/extends
		 (injava-inher
		  (let ((where (cdr injava-inher))
			(cont (car injava-inher)))
		    (goto-char where)
		    (cond ((looking-at "throws[ \t\n]")
			   (c-add-syntax 'func-decl-cont
					 (progn (c-beginning-of-statement-1 lim)
						(c-point 'boi))))
			  (cont (c-add-syntax 'inher-cont where))
			  (t (c-add-syntax 'inher-intro
					   (progn (goto-char (cdr injava-inher))
						  (c-beginning-of-statement-1 lim)
						  (point))))
			  )))
		 ;; CASE 5C.4: a continued inheritance line
		 (t
		  (c-beginning-of-inheritance-list lim)
		  (c-add-syntax 'inher-cont (point))
		  ;; don't add inclass symbol since relative point already
		  ;; contains any class offset
		  )))
	       ;; CASE 5D: this could be a top-level compound statement, a
	       ;; member init list continuation, or a template argument
	       ;; list continuation.
	       ((c-with-syntax-table (if (c-major-mode-is 'c++-mode)
					 c++-template-syntax-table
				       (syntax-table))
		  (save-excursion
		    (while (and (= (c-backward-token-1 1 t lim) 0)
				(not (looking-at "[;{<,]"))))
		    (eq (char-after) ?,)))
		(goto-char indent-point)
		(c-beginning-of-member-init-list lim)
		(cond
		 ;; CASE 5D.1: hanging member init colon, but watch out
		 ;; for bogus matches on access specifiers inside classes.
		 ((and (save-excursion
			 (setq placeholder (point))
			 (c-backward-token-1 1 t lim)
			 (and (eq (char-after) ?:)
			      (not (eq (char-before) ?:))))
		       (save-excursion
			 (goto-char placeholder)
			 (back-to-indentation)
			 (or
			  (/= (car (save-excursion
				     (parse-partial-sexp (point) placeholder)))
			      0)
			  (and
			   (if c-access-key (not (looking-at c-access-key)) t)
			   (not (looking-at c-class-key))
			   (if c-bitfield-key (not (looking-at c-bitfield-key)) t))
			  )))
		  (goto-char placeholder)
		  (c-forward-syntactic-ws)
		  (c-add-syntax 'member-init-cont (point))
		  ;; we do not need to add class offset since relative
		  ;; point is the member init above us
		  )
		 ;; CASE 5D.2: non-hanging member init colon
		 ((progn
		    (c-forward-syntactic-ws indent-point)
		    (eq (char-after) ?:))
		  (skip-chars-forward " \t:")
		  (c-add-syntax 'member-init-cont (point)))
		 ;; CASE 5D.3: perhaps a multiple inheritance line?
		 ((save-excursion
		    (c-beginning-of-statement-1 lim)
		    (setq placeholder (point))
		    (looking-at c-inher-key))
		  (goto-char placeholder)
		  (c-add-syntax 'inher-cont (c-point 'boi)))
		 ;; CASE 5D.4: perhaps a template list continuation?
		 ((save-excursion
		    (goto-char indent-point)
		    (skip-chars-backward "^<" lim)
		    ;; not sure if this is the right test, but it should
		    ;; be fast and mostly accurate.
		    (setq placeholder (point))
		    (and (eq (char-before) ?<)
			 (not (c-in-literal lim))))
		  ;; we can probably indent it just like an arglist-cont
		  (goto-char placeholder)
		  (c-beginning-of-statement-1 lim)
		  (c-add-syntax 'template-args-cont (c-point 'boi)))
		 ;; CASE 5D.5: perhaps a top-level statement-cont
		 (t
		  (c-beginning-of-statement-1 lim)
		  ;; skip over any access-specifiers
		  (and inclass-p c-access-key
		       (while (looking-at c-access-key)
			 (forward-line 1)))
		  ;; skip over comments, whitespace
		  (c-forward-syntactic-ws indent-point)
		  (c-add-syntax 'statement-cont (c-point 'boi)))
		 ))
	       ;; CASE 5E: we are looking at a access specifier
	       ((and inclass-p
		     c-access-key
		     (looking-at c-access-key))
		(c-add-syntax 'access-label (c-point 'bonl))
		(c-add-class-syntax 'inclass inclass-p))
	       ;; CASE 5F: extern-lang-close or namespace-close?
	       ((and inenclosing-p
		     (eq char-after-ip ?}))
		(setq tmpsymbol (if (eq inenclosing-p 'extern)
				    'extern-lang-close
				  'namespace-close))
		(c-add-syntax tmpsymbol (aref inclass-p 0)))
	       ;; CASE 5G: we are looking at the brace which closes the
	       ;; enclosing nested class decl
	       ((and inclass-p
		     (eq char-after-ip ?})
		     (save-excursion
		       (save-restriction
			 (widen)
			 (forward-char 1)
			 (and (c-safe (progn (c-backward-sexp 1) t))
			      (= (point) (aref inclass-p 1))
			      ))))
		(c-add-class-syntax 'class-close inclass-p))
	       ;; CASE 5H: we could be looking at subsequent knr-argdecls
	       ((and c-recognize-knr-p
		     ;; here we essentially use the hack that is used in
		     ;; Emacs' c-mode.el to limit how far back we should
		     ;; look.  The assumption is made that argdecls are
		     ;; indented at least one space and that function
		     ;; headers are not indented.
		     (let ((limit (save-excursion
				    (re-search-backward "^[^ \^L\t\n#]" nil 'move)
				    (point))))
		       (save-excursion
			 (c-backward-syntactic-ws limit)
			 (setq placeholder (point))
			 (while (and (memq (char-before) '(?\; ?,))
				     (> (point) limit))
			   (beginning-of-line)
			   (setq placeholder (point))
			   (c-backward-syntactic-ws limit))
			 (and (eq (char-before) ?\))
			      (or (not c-method-key)
				  (progn
				    (c-forward-sexp -1)
				    (forward-char -1)
				    (c-backward-syntactic-ws)
				    (not (or (memq (char-before) '(?- ?+))
					     ;; or a class category
					     (progn
					       (c-forward-sexp -2)
					       (looking-at c-class-key))
					     )))))
			 ))
		     (save-excursion
		       (c-beginning-of-statement-1)
		       (not (looking-at "typedef[ \t\n]+"))))
		(goto-char placeholder)
		(c-add-syntax 'knr-argdecl (c-point 'boi)))
	       ;; CASE 5I: ObjC method definition.
	       ((and c-method-key
		     (looking-at c-method-key))
		(c-add-syntax 'objc-method-intro (c-point 'boi)))
	       ;; CASE 5J: we are at the topmost level, make sure we skip
	       ;; back past any access specifiers
	       ((progn
		  (c-backward-syntactic-ws lim)
		  (while (and inclass-p
			      c-access-key
			      (not (bobp))
			      (save-excursion
				(c-safe (progn (c-backward-sexp 1) t))
				(looking-at c-access-key)))
		    (c-backward-sexp 1)
		    (c-backward-syntactic-ws lim))
		  (or (bobp)
		      (memq (char-before) '(?\; ?\}))))
		;; real beginning-of-line could be narrowed out due to
		;; enclosure in a class block
		(save-restriction
		  (widen)
		  (c-add-syntax 'topmost-intro (c-point 'bol))
		  (if inclass-p
		      (progn
			(goto-char (aref inclass-p 1))
			(or (= (point) (c-point 'boi))
			    (goto-char (aref inclass-p 0)))
			(cond
			 ((eq inenclosing-p 'extern)
			  (c-add-syntax 'inextern-lang (c-point 'boi)))
			 ((eq inenclosing-p 'namespace)
			  (c-add-syntax 'innamespace (c-point 'boi)))
			 (t (c-add-class-syntax 'inclass inclass-p)))
			))
		  ))
	       ;; CASE 5K: we are at an ObjC or Java method definition
	       ;; continuation line.
	       ((and c-method-key
		     (progn
		       (c-beginning-of-statement-1 lim)
		       (beginning-of-line)
		       (looking-at c-method-key)))
		(c-add-syntax 'objc-method-args-cont (point)))
	       ;; CASE 5L: we are at the first argument of a template
	       ;; arglist that begins on the previous line.
	       ((eq (char-before) ?<)
		(c-beginning-of-statement-1 lim)
		(c-forward-syntactic-ws)
		(c-add-syntax 'template-args-cont (c-point 'boi)))
	       ;; CASE 5M: we are at a topmost continuation line
	       (t
		(c-beginning-of-statement-1 lim)
		(c-forward-syntactic-ws)
		(c-add-syntax 'topmost-intro-cont (c-point 'boi)))
	       )) ; end CASE 5
	     ;; (CASE 6 has been removed.)
	     ;; CASE 7: line is an expression, not a statement.  Most
	     ;; likely we are either in a function prototype or a function
	     ;; call argument list
	     ((not (or (and c-special-brace-lists
			    (save-excursion
			      (goto-char containing-sexp)
			      (c-looking-at-special-brace-list)))
		       (eq (char-after containing-sexp) ?{)))
	      (c-backward-syntactic-ws containing-sexp)
	      (cond
	       ;; CASE 7A: we are looking at the arglist closing paren
	       ((and (or (c-major-mode-is 'pike-mode)
			 ;; Don't check this in Pike since it allows a
			 ;; comma after the last arg.
			 (not (eq char-before-ip ?,)))
		     (memq char-after-ip '(?\) ?\])))
		(goto-char containing-sexp)
		(setq placeholder (c-point 'boi))
		(when (and (c-safe (backward-up-list 1) t)
			   (> (point) placeholder))
		  (forward-char)
		  (skip-chars-forward " \t")
		  (setq placeholder (point)))
		(c-add-syntax 'arglist-close placeholder))
	       ;; CASE 7B: Looking at the opening brace of an
	       ;; in-expression block or brace list.
	       ((eq char-after-ip ?{)
		(goto-char indent-point)
		(setq placeholder (c-point 'boi))
		(goto-char containing-sexp)
		(if (c-inside-bracelist-p placeholder
					  (cons containing-sexp state))
		    (progn
		      (c-add-syntax 'brace-list-open (c-point 'boi))
		      (c-add-syntax 'inexpr-class))
		  (c-add-syntax 'block-open (c-point 'boi))
		  (c-add-syntax 'inexpr-statement)))
	       ;; CASE 7C: we are looking at the first argument in an empty
	       ;; argument list. Use arglist-close if we're actually
	       ;; looking at a close paren or bracket.
	       ((memq char-before-ip '(?\( ?\[))
		(goto-char containing-sexp)
		(setq placeholder (c-point 'boi))
		(when (and (c-safe (backward-up-list 1) t)
			   (> (point) placeholder))
		  (forward-char)
		  (skip-chars-forward " \t")
		  (setq placeholder (point)))
		(c-add-syntax 'arglist-intro placeholder))
	       ;; CASE 7D: we are inside a conditional test clause. treat
	       ;; these things as statements
	       ((save-excursion
		  (goto-char containing-sexp)
		  (and (c-safe (progn (c-forward-sexp -1) t))
		       (looking-at "\\<for\\>[^_]")))
		(goto-char (1+ containing-sexp))
		(c-forward-syntactic-ws indent-point)
		(c-beginning-of-statement-1 containing-sexp)
		(if (eq char-before-ip ?\;)
		    (c-add-syntax 'statement (point))
		  (c-add-syntax 'statement-cont (point))
		  ))
	       ;; CASE 7E: maybe a continued method call. This is the case
	       ;; when we are inside a [] bracketed exp, and what precede
	       ;; the opening bracket is not an identifier.
	       ((and c-method-key
		     (eq (char-after containing-sexp) ?\[)
		     (save-excursion
		       (goto-char (1- containing-sexp))
		       (c-backward-syntactic-ws (c-point 'bod))
		       (if (not (looking-at c-symbol-key))
			   (c-add-syntax 'objc-method-call-cont containing-sexp))
		       )))
	       ;; CASE 7F: we are looking at an arglist continuation line,
	       ;; but the preceding argument is on the same line as the
	       ;; opening paren.  This case includes multi-line
	       ;; mathematical paren groupings, but we could be on a
	       ;; for-list continuation line
	       ((save-excursion
		  (goto-char (1+ containing-sexp))
		  (skip-chars-forward " \t")
		  (not (eolp)))
		(goto-char containing-sexp)
		(setq placeholder (c-point 'boi))
		(when (and (c-safe (backward-up-list 1) t)
			   (> (point) placeholder))
		  (forward-char)
		  (skip-chars-forward " \t")
		  (setq placeholder (point)))
		(c-add-syntax 'arglist-cont-nonempty placeholder))
	       ;; CASE 7G: we are looking at just a normal arglist
	       ;; continuation line
	       (t (c-beginning-of-statement-1 containing-sexp)
		  (forward-char 1)
		  (c-forward-syntactic-ws indent-point)
		  (c-add-syntax 'arglist-cont (c-point 'boi)))
	       ))
	     ;; CASE 8: func-local multi-inheritance line
	     ((and c-baseclass-key
		   (save-excursion
		     (goto-char indent-point)
		     (skip-chars-forward " \t")
		     (looking-at c-baseclass-key)))
	      (goto-char indent-point)
	      (skip-chars-forward " \t")
	      (cond
	       ;; CASE 8A: non-hanging colon on an inher intro
	       ((eq char-after-ip ?:)
		(c-backward-syntactic-ws lim)
		(c-add-syntax 'inher-intro (c-point 'boi)))
	       ;; CASE 8B: hanging colon on an inher intro
	       ((eq char-before-ip ?:)
		(c-add-syntax 'inher-intro (c-point 'boi)))
	       ;; CASE 8C: a continued inheritance line
	       (t
		(c-beginning-of-inheritance-list lim)
		(c-add-syntax 'inher-cont (point))
		)))
	     ;; CASE 9: we are inside a brace-list
	     ((setq special-brace-list
		    (or (and c-special-brace-lists
			     (save-excursion
			       (goto-char containing-sexp)
			       (c-looking-at-special-brace-list)))
			(c-inside-bracelist-p containing-sexp state)))
	      (cond
	       ;; CASE 9A: In the middle of a special brace list opener.
	       ((and (consp special-brace-list)
		     (save-excursion
		       (goto-char containing-sexp)
		       (eq (char-after) ?\())
		     (eq char-after-ip (car (cdr special-brace-list))))
		(goto-char (car (car special-brace-list)))
		(skip-chars-backward " \t")
		(if (and (bolp)
			 (assoc 'statement-cont
				(setq placeholder (c-guess-basic-syntax))))
		    (setq syntax placeholder)
		  (c-beginning-of-statement-1 lim)
		  (c-forward-token-1 0)
		  (if (looking-at "typedef\\>") (c-forward-token-1 1))
		  (c-add-syntax 'brace-list-open (c-point 'boi))))
	       ;; CASE 9B: brace-list-close brace
	       ((if (consp special-brace-list)
		    ;; Check special brace list closer.
		    (progn
		      (goto-char (car (car special-brace-list)))
		      (save-excursion
			(goto-char indent-point)
			(back-to-indentation)
			(or
			 ;; We were between the special close char and the `)'.
			 (and (eq (char-after) ?\))
			      (eq (1+ (point)) (cdr (car special-brace-list))))
			 ;; We were before the special close char.
			 (and (eq (char-after) (cdr (cdr special-brace-list)))
			      (= (c-forward-token-1) 0)
			      (eq (1+ (point)) (cdr (car special-brace-list)))))))
		  ;; Normal brace list check.
		  (and (eq char-after-ip ?})
		       (c-safe (progn (forward-char 1)
				      (c-backward-sexp 1)
				      t))
		       (= (point) containing-sexp)))
		(c-add-syntax 'brace-list-close (c-point 'boi)))
	       (t
		;; Prepare for the rest of the cases below by going to the
		;; token following the opening brace
		(if (consp special-brace-list)
		    (progn
		      (goto-char (car (car special-brace-list)))
		      (c-forward-token-1 1 nil indent-point))
		  (goto-char containing-sexp))
		(forward-char)
		(let ((start (point)))
		  (c-forward-syntactic-ws indent-point)
		  (goto-char (max start (c-point 'bol))))
		(skip-chars-forward " \t\n\r" indent-point)
		(cond
		 ;; CASE 9C: we're looking at the first line in a brace-list
		 ((= (point) indent-point)
		  (goto-char containing-sexp)
		  (c-add-syntax 'brace-list-intro (c-point 'boi))
		  ) ; end CASE 9C
		 ;; CASE 9D: this is just a later brace-list-entry or
		 ;; brace-entry-open
		 (t (if (or (eq char-after-ip ?{)
			    (and c-special-brace-lists
				 (save-excursion
				   (goto-char indent-point)
				   (c-forward-syntactic-ws (c-point 'eol))
				   (c-looking-at-special-brace-list (point)))))
			(c-add-syntax 'brace-entry-open (point))
		      (c-add-syntax 'brace-list-entry (point))
		      )) ; end CASE 9D
		 )))) ; end CASE 9
	     ;; CASE 10: A continued statement
	     ((and (not (memq char-before-ip '(?\; ?:)))
		   (or (not (eq char-before-ip ?}))
		       (c-looking-at-inexpr-block-backward containing-sexp))
		   (> (point)
		      (save-excursion
			(c-beginning-of-statement-1 containing-sexp)
			(c-forward-syntactic-ws)
			(setq placeholder (point))))
		   (/= placeholder containing-sexp))
	      (goto-char indent-point)
	      (skip-chars-forward " \t")
	      (let ((after-cond-placeholder
		     (save-excursion
		       (goto-char placeholder)
		       (if (and c-conditional-key (looking-at c-conditional-key))
			   (progn
			     (c-safe (c-skip-conditional))
			     (c-forward-syntactic-ws)
			     (if (eq (char-after) ?\;)
				 (progn
				   (forward-char 1)
				   (c-forward-syntactic-ws)))
			     (point))
			 nil))))
		(cond
		 ;; CASE 10A: substatement
		 ((and after-cond-placeholder
		       (>= after-cond-placeholder indent-point))
		  (goto-char placeholder)
		  (if (eq char-after-ip ?{)
		      (c-add-syntax 'substatement-open (c-point 'boi))
		    (c-add-syntax 'substatement (c-point 'boi))))
		 ;; CASE 10B: open braces for class or brace-lists
		 ((setq special-brace-list
			(or (and c-special-brace-lists
				 (c-looking-at-special-brace-list))
			    (eq char-after-ip ?{)))
		  (cond
		   ;; CASE 10B.1: class-open
		   ((save-excursion
		      (goto-char indent-point)
		      (skip-chars-forward " \t{")
		      (let ((decl (c-search-uplist-for-classkey (c-parse-state))))
			(and decl
			     (setq placeholder (aref decl 0)))
			))
		    (c-add-syntax 'class-open placeholder))
		   ;; CASE 10B.2: brace-list-open
		   ((or (consp special-brace-list)
			(save-excursion
			  (goto-char placeholder)
			  (looking-at "\\<enum\\>"))
			(save-excursion
			  (goto-char indent-point)
			  (while (and (> (point) placeholder)
				      (= (c-backward-token-1 1 t) 0)
				      (/= (char-after) ?=)))
			  (eq (char-after) ?=)))
		    ;; The most semantically accurate symbol here is
		    ;; brace-list-open, but we report it simply as a
		    ;; statement-cont.  The reason is that one normally
		    ;; adjusts brace-list-open for brace lists as
		    ;; top-level constructs, and brace lists inside
		    ;; statements is a completely different context.
		    (goto-char indent-point)
		    (c-beginning-of-closest-statement)
		    (c-add-syntax 'statement-cont (c-point 'boi)))
		   ;; CASE 10B.3: The body of a function declared inside a
		   ;; normal block.  This can only occur in Pike.
		   ((and (c-major-mode-is 'pike-mode)
			 (progn
			   (goto-char indent-point)
			   (not (c-looking-at-bos))))
		    (c-beginning-of-closest-statement)
		    (c-add-syntax 'defun-open (c-point 'boi)))
		   ;; CASE 10B.4: catch-all for unknown construct.
		   (t
		    ;; Can and should I add an extensibility hook here?
		    ;; Something like c-recognize-hook so support for
		    ;; unknown constructs could be added.  It's probably a
		    ;; losing proposition, so I dunno.
		    (goto-char placeholder)
		    (c-add-syntax 'statement-cont (c-point 'boi))
		    (c-add-syntax 'block-open))
		   ))
		 ;; CASE 10C: iostream insertion or extraction operator
		 ((looking-at "<<\\|>>")
		  (goto-char placeholder)
		  (and after-cond-placeholder
		       (goto-char after-cond-placeholder))
		  (while (and (re-search-forward "<<\\|>>" indent-point 'move)
			      (c-in-literal placeholder)))
		  ;; if we ended up at indent-point, then the first
		  ;; streamop is on a separate line. Indent the line like
		  ;; a statement-cont instead
		  (if (/= (point) indent-point)
		      (c-add-syntax 'stream-op (c-point 'boi))
		    (c-backward-syntactic-ws lim)
		    (c-add-syntax 'statement-cont (c-point 'boi))))
		 ;; CASE 10D: continued statement. find the accurate
		 ;; beginning of statement or substatement
		 (t
		  (c-beginning-of-statement-1 after-cond-placeholder)
		  ;; KLUDGE ALERT!  c-beginning-of-statement-1 can leave
		  ;; us before the lim we're passing in.  It should be
		  ;; fixed, but I'm worried about side-effects at this
		  ;; late date.  Fix for v5.
		  (goto-char (or (and after-cond-placeholder
				      (max after-cond-placeholder (point)))
				 (point)))
		  (c-add-syntax 'statement-cont (point)))
		 )))
	     ;; CASE 11: an else clause?
	     ((looking-at "\\<else\\>[^_]")
	      (c-backward-to-start-of-if containing-sexp)
	      (c-add-syntax 'else-clause (c-point 'boi)))
	     ;; CASE 12: Statement. But what kind?  Lets see if its a
	     ;; while closure of a do/while construct
	     ((progn
		(goto-char indent-point)
		(skip-chars-forward " \t")
		(and (looking-at "while\\b[^_]")
		     (save-excursion
		       (c-backward-to-start-of-do containing-sexp)
		       (setq placeholder (point))
		       (looking-at "do\\b[^_]"))
		     ))
	      (goto-char placeholder)
	      (c-add-syntax 'do-while-closure (c-point 'boi)))
	     ;; CASE 13: A catch or finally clause?  This case is simpler
	     ;; than if-else and do-while, because a block is required
	     ;; after every try, catch and finally.
	     ((save-excursion
		(and (cond ((c-major-mode-is 'c++-mode)
			    (looking-at "\\<catch\\>[^_]"))
			   ((c-major-mode-is 'java-mode)
			    (looking-at "\\<\\(catch\\|finally\\)\\>[^_]")))
		     (c-safe (c-backward-sexp) t)
		     (eq (char-after) ?{)
		     (c-safe (c-backward-sexp) t)
		     (if (eq (char-after) ?\()
			 (c-safe (c-backward-sexp) t)
		       t)
		     (looking-at "\\<\\(try\\|catch\\)\\>[^_]")
		     (setq placeholder (c-point 'boi))))
	      (c-add-syntax 'catch-clause placeholder))
	     ;; CASE 14: A case or default label
	     ((looking-at c-switch-label-key)
	      (goto-char containing-sexp)
	      ;; check for hanging braces
	      (if (/= (point) (c-point 'boi))
		  (c-forward-sexp -1))
	      (c-add-syntax 'case-label (c-point 'boi)))
	     ;; CASE 15: any other label
	     ((looking-at c-label-key)
	      (goto-char containing-sexp)
	      ;; check for hanging braces
	      (if (/= (point) (c-point 'boi))
		  (c-forward-sexp -1))
	      (c-add-syntax 'label (c-point 'boi)))
	     ;; CASE 16: block close brace, possibly closing the defun or
	     ;; the class
	     ((eq char-after-ip ?})
	      (let* ((lim (c-safe-position containing-sexp fullstate))
		     (relpos (save-excursion
			       (goto-char containing-sexp)
			       (if (/= (point) (c-point 'boi))
				   (c-beginning-of-statement-1 lim))
			       (c-point 'boi))))
		(cond
		 ;; CASE 16A: closing a lambda defun or an in-expression
		 ;; block?
		 ((save-excursion
		    (goto-char containing-sexp)
		    (setq placeholder (c-looking-at-inexpr-block)))
		  (setq tmpsymbol (if (eq (car placeholder) 'inlambda)
				      'inline-close
				    'block-close))
		  (goto-char containing-sexp)
		  (back-to-indentation)
		  (if (= containing-sexp (point))
		      (c-add-syntax tmpsymbol (point))
		    (goto-char (cdr placeholder))
		    (back-to-indentation)
		    (c-add-syntax tmpsymbol (point))
		    (if (/= (point) (cdr placeholder))
			(c-add-syntax (car placeholder)))))
		 ;; CASE 16B: does this close an inline or a function in
		 ;; an extern block or namespace?
		 ((progn
		    (goto-char containing-sexp)
		    (setq placeholder (c-search-uplist-for-classkey state)))
		  (goto-char (aref placeholder 0))
		  (if (looking-at (concat c-extra-toplevel-key "[^_]"))
		      (c-add-syntax 'defun-close relpos)
		    (c-add-syntax 'inline-close relpos)))
		 ;; CASE 16C: if there an enclosing brace that hasn't
		 ;; been narrowed out by a class, then this is a
		 ;; block-close
		 ((and (not inenclosing-p)
		       (c-most-enclosing-brace state)
		       (or (not (c-major-mode-is 'pike-mode))
			   ;; In Pike it can be a defun-close of a
			   ;; function declared in a statement block.  Let
			   ;; it through to be handled below.
			   (or (c-looking-at-bos)
			       (progn
				 (c-beginning-of-statement-1)
				 (looking-at c-conditional-key)))))
		  (c-add-syntax 'block-close relpos))
		 ;; CASE 16D: find out whether we're closing a top-level
		 ;; class or a defun
		 (t
		  (save-restriction
		    (narrow-to-region (point-min) indent-point)
		    (let ((decl (c-search-uplist-for-classkey (c-parse-state))))
		      (if decl
			  (c-add-class-syntax 'class-close decl)
			(c-add-syntax 'defun-close relpos)))))
		 )))
	     ;; CASE 17: statement catchall
	     (t
	      ;; we know its a statement, but we need to find out if it is
	      ;; the first statement in a block
	      (goto-char containing-sexp)
	      (forward-char 1)
	      (c-forward-syntactic-ws indent-point)
	      ;; now skip forward past any case/default clauses we might find.
	      (while (or (c-skip-case-statement-forward fullstate indent-point)
			 (and (looking-at c-switch-label-key)
			      (not inswitch-p)))
		(setq inswitch-p t))
	      ;; we want to ignore non-case labels when skipping forward
	      (while (and (looking-at c-label-key)
			  (goto-char (match-end 0)))
		(c-forward-syntactic-ws indent-point))
	      (cond
	       ;; CASE 17A: we are inside a case/default clause inside a
	       ;; switch statement.  find out if we are at the statement
	       ;; just after the case/default label.
	       ((and inswitch-p
		     (progn
		       (goto-char indent-point)
		       (c-beginning-of-statement-1 containing-sexp)
		       (setq placeholder (point))
		       (beginning-of-line)
		       (when (re-search-forward c-switch-label-key
						(max placeholder (c-point 'eol)) t)
			 (setq placeholder (match-beginning 0)))))
		(goto-char indent-point)
		(skip-chars-forward " \t")
		(if (eq (char-after) ?{)
		    (c-add-syntax 'statement-case-open placeholder)
		  (c-add-syntax 'statement-case-intro placeholder)))
	       ;; CASE 17B: continued statement
	       ((eq char-before-ip ?,)
		(goto-char indent-point)
		(c-beginning-of-closest-statement)
		(c-add-syntax 'statement-cont (c-point 'boi)))
	       ;; CASE 17C: a question/colon construct?  But make sure
	       ;; what came before was not a label, and what comes after
	       ;; is not a globally scoped function call!
	       ((or (and (memq char-before-ip '(?: ??))
			 (save-excursion
			   (goto-char indent-point)
			   (c-backward-syntactic-ws lim)
			   (back-to-indentation)
			   (not (looking-at c-label-key))))
		    (and (memq char-after-ip '(?: ??))
			 (save-excursion
			   (goto-char indent-point)
			   (skip-chars-forward " \t")
			   ;; watch out for scope operator
			   (not (looking-at "::")))))
		(goto-char indent-point)
		(c-beginning-of-closest-statement)
		(c-add-syntax 'statement-cont (c-point 'boi)))
	       ;; CASE 17D: any old statement
	       ((< (point) indent-point)
		(let ((safepos (c-most-enclosing-brace fullstate))
		      relpos done)
		  (goto-char indent-point)
		  (c-beginning-of-statement-1 safepos)
		  ;; It is possible we're on the brace that opens a nested
		  ;; function.
		  (if (and (eq (char-after) ?{)
			   (save-excursion
			     (c-backward-syntactic-ws safepos)
			     (not (eq (char-before) ?\;))))
		      (c-beginning-of-statement-1 safepos))
		  (if (and inswitch-p
			   (looking-at c-switch-label-key))
		      (progn
			(goto-char (match-end 0))
			(c-forward-syntactic-ws)))
		  (setq relpos (c-point 'boi))
		  (while (and (not done)
			      (<= safepos (point))
			      (/= relpos (point)))
		    (c-beginning-of-statement-1 safepos)
		    (if (= relpos (c-point 'boi))
			(setq done t))
		    (setq relpos (c-point 'boi)))
		  (c-add-syntax 'statement relpos)
		  (if (eq char-after-ip ?{)
		      (c-add-syntax 'block-open))))
	       ;; CASE 17E: first statement in an in-expression block
	       ((setq placeholder
		      (save-excursion
			(goto-char containing-sexp)
			(c-looking-at-inexpr-block)))
		(goto-char containing-sexp)
		(back-to-indentation)
		(let ((block-intro (if (eq (car placeholder) 'inlambda)
				       'defun-block-intro
				     'statement-block-intro)))
		  (if (= containing-sexp (point))
		      (c-add-syntax block-intro (point))
		    (goto-char (cdr placeholder))
		    (back-to-indentation)
		    (c-add-syntax block-intro (point))
		    (if (/= (point) (cdr placeholder))
			(c-add-syntax (car placeholder)))))
		(if (eq char-after-ip ?{)
		    (c-add-syntax 'block-open)))
	       ;; CASE 17F: first statement in an inline, or first
	       ;; statement in a top-level defun. we can tell this is it
	       ;; if there are no enclosing braces that haven't been
	       ;; narrowed out by a class (i.e. don't use bod here!)
	       ((save-excursion
		  (save-restriction
		    (widen)
		    (goto-char containing-sexp)
		    (c-narrow-out-enclosing-class state containing-sexp)
		    (not (c-most-enclosing-brace state))))
		(goto-char containing-sexp)
		;; if not at boi, then defun-opening braces are hung on
		;; right side, so we need a different relpos
		(if (/= (point) (c-point 'boi))
		    (progn
		      (c-backward-syntactic-ws)
		      (c-safe (c-forward-sexp (if (eq (char-before) ?\))
						  -1 -2)))
		      ;; looking at a Java throws clause following a
		      ;; method's parameter list
		      (c-beginning-of-statement-1)
		      ))
		(c-add-syntax 'defun-block-intro (c-point 'boi)))
	       ;; CASE 17G: First statement in a function declared inside
	       ;; a normal block.  This can only occur in Pike.
	       ((and (c-major-mode-is 'pike-mode)
		     (progn
		       (goto-char containing-sexp)
		       (and (not (c-looking-at-bos))
			    (progn
			      (c-beginning-of-statement-1)
			      (not (looking-at c-conditional-key))))))
		(c-add-syntax 'defun-block-intro (c-point 'boi)))
	       ;; CASE 17H: first statement in a block
	       (t (goto-char containing-sexp)
		  (if (/= (point) (c-point 'boi))
		      (c-beginning-of-statement-1
		       (if (= (point) lim)
			   (c-safe-position (point) state) lim)))
		  (c-add-syntax 'statement-block-intro (c-point 'boi))
		  (if (eq char-after-ip ?{)
		      (c-add-syntax 'block-open)))
	       ))
	     )
	    ;; now we need to look at any modifiers
	    (goto-char indent-point)
	    (skip-chars-forward " \t")
	    (cond
	     ;; are we looking at a comment only line?
	     ((and (looking-at c-comment-start-regexp)
		   (/= (c-forward-token-1 0 nil (c-point 'eol)) 0))
	      (c-add-syntax 'comment-intro))
	     ;; we might want to give additional offset to friends (in C++).
	     ((and (c-major-mode-is 'c++-mode)
		   (looking-at c-C++-friend-key))
	      (c-add-syntax 'friend))
	     ;; Start of a preprocessor directive?
	     ((and (eq literal 'pound)
		   (= (save-excursion
			(c-beginning-of-macro lim)
			(setq placeholder (point)))
		      (c-point 'boi))
		   (not (and (c-major-mode-is 'pike-mode)
			     (eq (char-after (1+ placeholder)) ?\"))))
	      (c-add-syntax 'cpp-macro)))
	    ;; return the syntax
	    syntax))))
    )
   )
  )

(provide 'post-java-mode)

