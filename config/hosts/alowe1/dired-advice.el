(put 'dired-advice 'rcsid
 "$Id: dired-advice.el,v 1.1 2003-09-23 16:01:43 cvs Exp $")

(chain-parent-file t)

(require 'advice)

;; if we're in dired under vc mode, and descending into a subdirectory, stay in vc mode

(defadvice dired-find-file (around 
			    vc-dired-find-file
			    first activate)
  ""

  (if (and (eq major-mode 'vc-dired-mode) 
	   (file-directory-p (dired-get-filename)))
      (vc-directory (dired-get-filename) nil)
  ; otherwise, just do it.
    ad-do-it
    )
  )

; (ad-is-advised 'dired-find-file)
; (ad-unadvise 'dired-find-file)


