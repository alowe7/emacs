(put 'post-man 'rcsid 
 "$Id: post-man.el,v 1.6 2002-11-22 17:02:12 cvs Exp $")

(require 'advice)

(defun fix-man-page ()
  (interactive)
  (save-excursion
    (kill-pattern "_") ; hack for roff underlining
    (kill-pattern ".")
    (kill-pattern "8")
    (kill-pattern "9")
    ))

;; wrap man to whack its path
(defadvice man (around 
		hook-man
		first activate)
  ""

  (let ((process-environment (nconc (list "PATH=\\a\\bin;\\usr\\local\\bin;\\contrib\\bin;\\usr\\bin;\\bin") process-environment)))
    (cd "/") ; cd into the root filesystem, wherever it is.
    ad-do-it
    )
  )

; (ad-is-advised 'man)
; (ad-unadvise 'man)

