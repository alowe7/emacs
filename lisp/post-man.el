(put 'post-man 'rcsid 
 "$Id: post-man.el,v 1.4 2002-01-10 18:47:23 cvs Exp $")

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

