(put 'post-xdb 'rcsid 
 "$Id: post-xdb.el,v 1.8 2003-04-03 04:30:07 cvs Exp $")

(require 'advice)
(require 'cat-utils)

(defvar *xdb-domain* (string* (getenv "XDBDOMAIN") "alowe.com"))

;; this hook tries to be smarter about which side of evilnat we're on.

(defadvice x-query (around 
		    hook-x-query
		    first activate)
  ""

  (if (and (fboundp 'evilnat) (not (member "-h" *txdb-options*)))
      (let ((*txdb-options* 
	     (nconc
		    (list "-h" 
			  (concat (getenv "XDBHOST")
				  (unless (evilnat) (concat "." *xdb-domain*))
				  )
			  )
		    *txdb-options* 
		    )
	     )
	    )
	ad-do-it
	)
  ; otherwise, just do it
    ad-do-it
    )
  )

; (ad-is-advised 'x-query)
; (ad-unadvise 'x-query)

(defun iexplore ()
  (interactive)
  (if (save-excursion (backward-word 1) (looking-at "http://[a-zA-Z0-9.-/]+"))
      (let ((htm (buffer-substring (match-beginning 0) (match-end 0))))
	(aexec htm)
	t
	)
    )
  )

(add-hook 'x-query-mode-hook '(lambda ()
				(loop for x across "/:\.-" do (modify-syntax-entry x "w"))
				))

; (pop x-query-mode-hook)
; (run-hooks (quote x-query-mode-hook))

; first time through, ask for a sword

(let ((sword  (comint-read-noecho "sword: ")))
  (if (string* sword)
      (setq *txdb-options* 
	    (nconc
	     (list "-s" sword)
	     *txdb-options* 
	     )
	    )
    )
  )
