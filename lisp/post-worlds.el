
(add-hook 'world-init-hook 
	  (function
	   (lambda () (lastworld)
	     (add-hook 'after-save-hook 'world-file-save-hook))))


