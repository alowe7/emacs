(put 'perl-helpers 'rcsid
 "$Id: perl-helpers.el,v 1.1 2002-06-06 12:02:31 cvs Exp $")

;; run perl script on region.  default is same as last time, any if
(defvar *last-perl-script* "")

(defun perl-command-region-1 (script)
  (interactive (list (read-string "script: ")))
  (let ((p (point))
	(m (mark))
	(b (get-buffer-create "*perl output*"))
	(script (string* (string* script *last-perl-script*)
			 (read-string "script: "))))
    (if (setq *last-perl-script* (string* script))
	(progn
	  (perl-command-region p m script nil b nil)
	  (message (save-excursion (set-buffer b) (buffer-string)))
	  (kill-buffer b)
	  )
      )
    )
  )

