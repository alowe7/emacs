(put 'wordkeys 'rcsid 
 "$Id: wordkeys.el,v 1.1 2001-04-27 11:38:00 cvs Exp $")

(defvar *wordkeys* "/a/n/howto/wordkeys.txt")

(defun wordkey (pat)
  (interactive "scommand: ")
  (let* ((s (eval-process "egrep" "-i" pat *wordkeys*))
	 (n (length (split s "
"))))

    (if (< n 2)
	(message (buffer-string))
      (let ((b  (zap-buffer "*wordkeys*")))
	(insert s)
	(pop-to-buffer b)
	(not-modified)
	(setq buffer-read-only t)
	(beginning-of-buffer) 
	(view-mode)))))
