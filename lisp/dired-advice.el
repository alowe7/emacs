(put 'dired-advice 'rcsid 
 "$Id: dired-advice.el,v 1.7 2002-01-10 18:47:23 cvs Exp $")

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

; (ad-unadvise 'dired-noselect)
; (dired "//deadite/C")

(defadvice find-file-noselect (around 
			       hook-find-file-noselect
			       first activate)
  ""

  ; make sure host exists
  (host-ok (ad-get-arg 0))
  ; otherwise, just do it.
  ad-do-it
  )


;; wrap dired-do-compress to check for .zip files
(defadvice dired-do-compress (around 
			      hook-dired-do-compress
			      first activate)
  ""

  (if (string-equal "zip" (downcase (file-name-extension (dired-get-filename))))
      (progn (save-window-excursion
	       (zip-extract (dired-get-filename)))
	     (revert-buffer))
  ; otherwise, just do it.
    ad-do-it
    )
  )

; (ad-is-advised 'dired-do-compress)
; (ad-unadvise 'dired-do-compress)

(provide 'dired-advice)
