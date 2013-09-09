(put 'myblog2-extra 'rcsid
 "$Id$")

; auto-autoloads

(add-hook 'myblog2-hooks
	  (function (lambda ()
	     (require 'ctl-slash)
	     (define-key ctl-/-map "g" 'grepblog)
	     (define-key ctl-/-map "l" 'lastblog)
	     (define-key ctl-/-map "n" 'myblog2)
	     ))
	  )


