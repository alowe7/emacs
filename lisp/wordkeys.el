(put 'wordkeys 'rcsid 
 "$Id: wordkeys.el,v 1.2 2004-08-11 14:55:53 cvs Exp $")

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
	(set-buffer-modified-p nil)
	(setq buffer-read-only t)
	(beginning-of-buffer) 
	(view-mode)))))
