(put 'post-man 'rcsid 
 "$Id: post-man.el,v 1.1 2003-09-03 18:15:54 cvs Exp $")

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

; need (default-directory "/") if cygroot is not current

  (let ((process-environment 
	 (nconc
	  (list
	   "MANPATH=/usr/man:/contrib/man"
	   "PATH=\\a\\bin;\\usr\\local\\bin;\\contrib\\bin;\\usr\\bin;\\bin")
	  process-environment))
	)
 ; be sure you're in the root filesystem, wherever it is mounted
    ad-do-it
    )
  )

; (ad-is-advised 'man)
; (ad-unadvise 'man)

