(put 'post-man 'rcsid 
 "$Id: post-man.el,v 1.4 2004-02-12 16:34:36 cvs Exp $")

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
	   "MANPATH=/usr/local/main:/contrib/man:/usr/man"
	   "PATH=\\a\\bin;\\usr\\local\\bin;\\contrib\\bin;\\usr\\bin;\\bin")
	  process-environment))
	)
  ; be sure you're in the root filesystem, wherever it is mounted
	ad-do-it
    )
  )

; (if (ad-is-advised 'man) (ad-unadvise 'man))

;; use the following to catch not found errors

(defadvice Man-goto-page (around 
 			  hook-Man-goto-page
 			  first activate)
  ""
  (condition-case x
      ad-do-it
    (error 
     (message "not found")
    )
  )
)

; (if (ad-is-advised 'Man-goto-page) (ad-unadvise 'Man-goto-page)) 

(defadvice man (around 
		hook-man
		first activate)
  ""

  (let* ((arg (ad-get-arg 0) )
	 (l (or (ff (format "/%s.pod" arg)) (ff (format "/%s.pod" arg))))
	 (podfn (loop for p in l thereis (-f p))))
    (if podfn (pod podfn)
      ad-do-it)
    )
  )

; (if (ad-is-advised 'man) (ad-unadvise 'man)) 

