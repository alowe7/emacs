(put 'post-xdb 'rcsid 
 "$Id: post-xdb.el,v 1.3 2002-03-13 17:58:49 cvs Exp $")

(require 'advice)
(require 'cat-utils)

(defvar *default-domain* ".alowe.com")

;; this hook tries to be smarter about which side of evilnat we're on.

(defadvice x-query (around 
		    hook-x-query
		    first activate)
  ""

  (if (and (fboundp 'evilnat) (not (member "-h" *txdb-options*)))
      (let ((*txdb-options* 
	     (nconc *txdb-options* 
		    (list "-h" 
			  (concat (getenv "XDBHOST")
				  (unless (evilnat) *default-domain*)
				  )
			  )
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
				(define-key x-query-mode-map "" '(lambda () (interactive) (or (iexplore) (newline))))))

; (pop x-query-mode-hook)
; (run-hooks (quote x-query-mode-hook))