(put 'post-man 'rcsid 
 "$Id: post-man.el,v 1.3 2004-01-30 14:47:04 cvs Exp $")

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
    (error (debug))
    ;;      (let* ((p1 (and (string-match "Can't find the " (cadr x)) (match-end 0)))
    ;; 	    (p2 (and p1 (string-match " manpage" (cadr x)) (match-beginning 0)))
    ;; 	    (arg (and p2 (substring (cadr x) p1 p2))))
    ;;   ; try a shot in the dark
    ;;        (eval-process arg "/?")
    ;;        )
    )
  )
 
; (if (ad-is-advised 'Man-goto-page) (ad-unadvise 'Man-goto-page)) 
