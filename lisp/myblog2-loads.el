(put 'myblog2-extra 'rcsid
 "$Id: myblog2-loads.el,v 1.1 2008-09-27 16:34:01 keystone Exp $")

; auto-autoloads

(add-hook 'myblog2-hooks
	  '(lambda ()
	     (require 'ctl-slash)
	     (define-key ctl-/-map "g" 'grepblog)
	     (define-key ctl-/-map "l" 'lastblog)
	     (define-key ctl-/-map "n" 'myblog2)
	     )
	  )


