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

(provide 'post-java-mode)

