(defconst rcs-id "$Id: dired-advice.el,v 1.3 2000-07-30 21:07:45 andy Exp $")

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