
(add-hook 'compilation-completion-hook
					'(lambda () 
						 (set-buffer "*compilation*")
						 (qsave-search (current-buffer) compile-command)
						 (use-local-map compilation-mode-map)
						 ))