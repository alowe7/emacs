(defconst rcs-id "$Id: post-worlds.el,v 1.3 2000-07-30 21:07:47 andy Exp $")

(add-hook 'world-init-hook 
	  (function
	   (lambda () (lastworld)
	     (add-hook 'after-save-hook 'world-file-save-hook))))


