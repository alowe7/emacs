(put 'post-vc 'rcsid
 "$Id$")

(require 'cat-utils) ;; just for chomp

(defun has-identity-expression ()
  "predicate true if buffer contains a valid rcsid string
"
  ; be a predicate
  (not (not (identity-expression)))
  )
; (has-identity-expression)

(defun identity-expression ()
  "evaluates to the rcs identity expression contained in a buffer
"
  (let ((identity-expression
	 "\\$Id:[^$]+\\$"
	 ))
    (if (string-match identity-expression (buffer-string))
	(remove-text-properties-from-string (substring (buffer-string) (match-beginning 0) (match-end 0))))
    )
  )
; (identity-expression)

(defun identify () 
  "insert a sccs ID string at head of file."
  (interactive)
  (goto-char (point-min))
  ;; quote dollars to avoid keyword expansion here
  (insert
   (if (eq major-mode 'emacs-lisp-mode)
       (format "(put '%s 'rcsid\n \"\$Id\$\")\n" 
	       (intern (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
     (format "%s \$Id\$ %s\n" (or comment-start "#") (or comment-end ""))
     )
   )
  )

;; fixup crlf eol encoding
(add-hook 'vc-checkin-hook '(lambda () (find-file-force-refresh)))

(defun rcsid (&optional arg) 
  "return rcsid associated with current buffer.
with optional ARG, if ARG is a string or symbol, check for library with matching name
else if ARG, prompt for file name. 
if module is part of a specialization chain,  return closure of rcsids of ancestors as a list 
see `chain-parent-file'
"
  (interactive "P")
  (let* ((f (cond ((and arg (stringp arg)) arg)
		  ((and arg (symbolp arg)) (symbol-name arg))
		  (arg (read-file-name "file: "))
		  (t (buffer-file-name))))
	 (base (and f (intern (file-name-sans-extension (file-name-nondirectory f)))))
	 (id (and base (get base (quote rcsid))))
	 (chain (and base (get base (quote rcsid-chain))))
	 )
    (if (interactive-p)
	(cond
	 (id
	  (message (chomp (pp (nconc (list id) chain)))))
	 ((setq id (identity-expression))
	  (message (format "rcsid: %s" id)))
	 ((y-or-n-p (format "rcsid for library %s not defined.  identify?" f))
	  (identify))
	 )
      )
    id)
  )

(require 'advice)

(defadvice vc-diff (after 
		    hook-vc-diff
		    first activate)
  ""

  (turn-on-font-lock)
  (setq tab-width 4)
  (recenter)
  )

; (ad-is-advised 'vc-diff)
; (ad-unadvise 'vc-diff)

(defun cvshack () (interactive) (perl-command-1 "cvshack" :show t :args '("-r" "-v")))

;; non-terse makes more sense for cvs 
(setq vc-dired-terse-display nil)

(let ((new-diff-switches (list "-b")))
  (if (stringp diff-switches)
      (setq diff-switches (list diff-switches)))
  (loop for x in new-diff-switches do (add-to-list 'diff-switches x))
  diff-switches)

(define-key vc-prefix-map "!" 'cvshack)
(define-key vc-prefix-map "?" '(lambda () (interactive) (message "file %s is %s" (buffer-file-name) (vc-cvs-status (buffer-file-name)))))

(autoload 'ediff-revision "ediff")
(define-key vc-prefix-map "@" 'ediff-revision)
