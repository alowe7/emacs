(put 'pre-info 'rcsid
 "$Id$")

(require 'advice)

; this isn't working for some reason...

(if nil
    (defadvice info (around 
		     hook-info
		     first activate)
      ""

      (let ((default-directory "/"))
	ad-do-it
	)
      )
  )

; (if (ad-is-advised 'info) (ad-unadvise 'info))
