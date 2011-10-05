(put 'post-perl-mode 'rcsid
 "$Id: post-perl-mode.el 1017 2011-06-06 04:32:11Z alowe $")

(defun perldoc (thing)
  "find perldoc for THING"
  (interactive "sperldoc: ")
  (let* ((*perl-command* "/bin/perl")
	 (b (zap-buffer (format "*perldoc %s*" thing)))
	 (s1 (perl-command perldoc-cmd thing))
	 (s (replace-in-string "\[[0-9]+m" "" s1))
	 )

    (set-buffer b)
    (insert s)
    (pop-to-buffer b)
    (goto-char (point-min))
    (view-mode)
    )
  )

; (perldoc "perlref")
; (let ((*perl-command* "/bin/perl"))
;   (perldoc "perlref")
;  )

; I think lazy-lock-mode is no longer supported?
; (add-hook 'perl-mode-hook '(lambda () (lazy-lock-mode)))
