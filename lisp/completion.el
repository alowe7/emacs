
(provide 'completion)

;; name lists for autocompletion in misc. modes

(defun my-complete-symbol (oblist)
  "Perform completion on C symbol preceding point.
That symbol is compared against the symbols that exist
and any additional characters determined by what is there
are inserted."
  (let* ((end (point))
	 (beg (save-excursion
		(backward-sexp 1)
		(point)))
	 (pattern (buffer-substring beg end))
;;	 (predicate
;;	  (if (eq (char-after (1- beg)) ?\()
;;	      'fboundp
;;	    (function (lambda (sym)
;;			(or (boundp sym) (fboundp sym)
;;			    (symbol-plist sym))))))
	 (predicate nil)
	 (completion (try-completion pattern oblist predicate)))
    (cond ((eq completion t))
	  ((null completion)
	   (message "Can't find completion for \"%s\"" pattern)
	   (ding))
	  ((not (string= pattern completion))
	   (delete-region beg end)
	   (insert completion))
	  (t
	   (message "Making completion list...")
	   (let ((list (all-completions pattern oblist predicate)))
;;	     (or (eq predicate 'fboundp)
;;		 (let (new)
;;		   (while list
;;		     (setq new (cons (if (fboundp (intern (car list)))
;;					 (list (car list) " <f>")
;;				       (car list))
;;				     new))
;;		     (setq list (cdr list)))
;;		   (setq list (nreverse new))))
	     (with-output-to-temp-buffer " *Completions*"
	       (display-completion-list list)))
	   (message "Making completion list...%s" "done")))))

(defun c-complete-symbol ()
  "Perform completion on C symbol preceding point."
  (interactive)
  (my-complete-symbol c-obarray))

(defun shell-complete-symbol ()
  "Perform completion on C symbol preceding point."
  (interactive)
  (my-complete-symbol shell-obarray))
