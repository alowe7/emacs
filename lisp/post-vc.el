(put 'post-vc 'rcsid
 "$Id: post-vc.el,v 1.9 2002-03-08 18:33:27 cvs Exp $")

(defun identify () 
  "insert a sccs ID string at head of file."
  (interactive)
  (let ((id (intern (file-name-sans-extension (file-name-nondirectory (buffer-file-name))))))
    (goto-char (point-min))
    ;; quote dollars to avoid keyword expansion here
    (insert
     (cond ((or (eq major-mode 'sh-mode) (eq major-mode 'perl-mode))
	    "# \$Id\$\n")
	   ((eq major-mode 'emacs-lisp-mode)
	    (format "(put '%s 'rcsid\n \"\$Id\$\")\n" id))))
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
	 (id (and f (get (intern (file-name-sans-extension (file-name-nondirectory f))) (quote rcsid)))))
    (if (interactive-p)
	(message (or id (format "no rcsid for library %s" f)))
      id)
    )
  )

(require 'advice)

(defadvice vc-diff (after 
		    hook-vc-diff
		    first activate)
  ""

  (turn-on-lazy-lock)
  (setq tab-width 4)
  (recenter)
  )

; (ad-is-advised 'vc-diff)
; (ad-unadvise 'vc-diff)

(defun cvshack () (interactive) (perl-command "cvshack" "-r"))
(define-key vc-prefix-map "!" 'cvshack)
