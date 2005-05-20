(put 'hook-find-file-noselect 'rcsid
 "$Id: hook-find-file-noselect.el,v 1.1 2005-05-20 20:24:53 cvs Exp $")

;; hook find-file to smash dos style letter drive names into well known mount points

(defvar *mount-list* nil "list of mounted directories.  should be set in host initialization files")
 
(defadvice find-file-noselect (around 
			       hook-find-file-noselect-smash
			       first activate)
  ""

  (if (and (not (file-exists-p (ad-get-arg 0)))
	   (string-match "^[A-Z]:" filename))

      (let* ((d (assoc (upcase (substring filename (match-beginning 0) (match-end 0)))
		       *mount-list*))
	     (f (concat (cadr d) (substring filename (match-end 0)))))
	(if (file-exists-p f) (ad-set-arg 0 f))
	)
    )
  ad-do-it

  )



; (ad-is-advised 'find-file-noselect)
; (ad-unadvise 'find-file-noselect)
