(put 'dired-advice 'rcsid 
 "$Id: dired-advice.el,v 1.6 2001-02-09 14:29:51 cvs Exp $")

(require 'advice)

;; these hooks are designed to prevent a call to view a networked drive 
;; when a ping to the host times out
;; the default timeout is usually hardcoded into lower level software
;; (host-ok) is enncoded in an os-specific module

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