(add-hook 'logview-mode-hook
	  `(lambda () 
	     (define-key logview-mode-map "" 'highlight-next-line)
	     (define-key logview-mode-map "" 'highlight-previous-line)
	     )
	  )
