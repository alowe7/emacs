;; override sgml-list-implications to not popup the stupid error buffer

(defvar bang nil "this is a hack to avoid popping up the all too frequent error buffer")

(defun sgml-list-implications (token type)
  "Return a list of the tags implied by a token TOKEN.
TOKEN is a token, and the list elements are either tokens or `t'.
Where the latter represents end-tags."
  (let ((state sgml-current-state)
	(tree sgml-current-tree)
	(temp nil)
	(imps nil))
    (while				; Until token accepted
	(cond
	 ;; Test if accepted in state
	 ((or (eq state sgml-any)
	      (and (sgml-model-group-p state)
		   (not (memq token (sgml-tree-excludes tree)))
		   (or (memq token (sgml-tree-includes tree))
		       (sgml-get-move state token))))
	  nil)
	 ;; Test if end tag implied
	 ((or (eq state sgml-empty)
	      (and (sgml-final-p state)
		   (not (eq tree sgml-top-tree))))
	  (unless (eq state sgml-empty)	; not really implied
	    (push t imps))
	  (setq state (sgml-tree-pstate tree)
		tree (sgml-fake-close-element tree))
	  t)
	 ;; Test if start-tag can be implied
	 ((and (setq temp (sgml-required-tokens state))
	       (null (cdr temp)))
	  (setq temp (car temp)
		tree (sgml-fake-open-element tree temp
					     (sgml-get-move state temp))
		state (sgml-element-model tree))
	  (push temp imps)
	  t)
	 ;; No implictions and not accepted
	 (t
	  (and bang (debug)) ;;; XXX
	  (sgml-log-warning "Out of context %s" type)
	  (setq imps nil))))
    ;; Return the implications in correct order
    (nreverse imps)))
