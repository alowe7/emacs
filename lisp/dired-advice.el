(put 'dired-advice 'rcsid 
 "$Id$")

(require 'advice)

;; these hooks are designed to prevent a call to view a networked drive 
;; when a ping to the host times out
;; the default timeout is usually hardcoded into lower level software
;; (host-ok) is enncoded in an os-specific module

(defadvice dired-noselect (around 
			   hook-dired-noselect
			   first activate)
  ""

  (let ((dir (ad-get-arg 0)))
  ; signal file-error unless host exists
    (and (fboundp 'host-ok) (host-ok dir))
  ; otherwise, just do it.
    ad-do-it
    )
  )

; (if (ad-is-advised 'dired-noselect) (ad-unadvise 'dired-noselect))
; (dired "//deadite/C")

(defadvice find-file-noselect (around 
			       hook-find-file-noselect
			       first activate)
  ""

  ; signal file-error unless host exists
  (let ((f (ad-get-arg 0)))
    (and (fboundp 'host-ok) (host-ok f))
  ; otherwise, just do it.
    ad-do-it
    )
  )
; (if (ad-is-advised 'find-file-noselect) (ad-unadvise 'find-file-noselect))


(provide 'dired-advice)
