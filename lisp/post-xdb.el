(put 'dired-advice 'rcsid 
 "$Id: post-xdb.el,v 1.1 2002-03-08 18:15:30 cvs Exp $")

(require 'advice)

(defvar *default-domain* ".alowe.com")

;; this hook tries to be smarter about which side of evilnat we're on.

(defadvice x-query (around 
			   hook-x-query
			   first activate)
  ""

  (if (and (fboundp 'evilnat) (not (member "-h" *txdb-options*)))
      (let ((*txdb-options* 
	     (nconc *txdb-options* (list "-h" (concat (getenv "XDBHOST") (unless (evilnat) *default-domain*))))))
	ad-do-it
	)
  ; otherwise, just do it
    ad-do-it
    )
)

; (ad-is-advised 'x-query)
; (ad-unadvise 'x-query)