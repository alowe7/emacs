(defconst rcs-id "$Id: post-compilation.el,v 1.3 2000-07-30 21:07:47 andy Exp $")

(add-hook 'compilation-completion-hook
					'(lambda () 
						 (set-buffer "*compilation*")
						 (qsave-search (current-buffer) compile-command)
						 (use-local-map compilation-mode-map)
						 ))