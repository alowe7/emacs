(put 'post-perl-mode 'rcsid
 "$Id: post-perl-mode.el 1043 2012-02-22 16:25:27Z alowe $")

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
(define-key help-map "d" 'perldoc)

; (perldoc "perlref")
; (let ((*perl-command* "/bin/perl"))
;   (perldoc "perlref")
;  )

; I think lazy-lock-mode is no longer supported?
; (add-hook 'perl-mode-hook (lambda () (lazy-lock-mode)))
