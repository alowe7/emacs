(put 'pre-info 'rcsid
 "$Id: pre-info.el,v 1.1 2003-09-23 20:40:40 cvs Exp $")

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
