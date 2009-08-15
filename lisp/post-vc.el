(put 'post-vc 'rcsid
 "$Id: post-vc.el,v 1.18 2009-08-15 17:40:27 alowe Exp $")

(require 'cat-utils) ;; just for chomp

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
else if ARG, read file name. "
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
	(if id
	    (message (chomp (pp (nconc (list id) chain))))
	  (if (y-or-n-p (format "no rcsid for library %s.  identify?" f))
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
