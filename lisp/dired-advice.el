(put 'dired-advice 'rcsid 
 "$Id: dired-advice.el,v 1.5 2000-10-03 16:50:27 cvs Exp $")

(require 'advice)


(defadvice dired-noselect (around 
			   hook-dired-noselect
			   first activate)
  ""

  ; make sure host exists
  (host-ok (ad-get-arg 0))
  ; otherwise, just do it.
  ad-do-it
)

(defadvice find-file-noselect (around 
			       hook-find-file-noselect
			       first activate)
  ""

  ; make sure host exists
  (host-ok (ad-get-arg 0))
  ; otherwise, just do it.
  ad-do-it
  )

; (ad-unadvise 'dired-noselect)
; (dired "//deadite/C")