(put 'post-compilation 'rcsid "$Id: post-compilation.el,v 1.4 2000-10-03 16:44:07 cvs Exp $")

(add-hook 'compilation-completion-hook
					'(lambda () 
						 (set-buffer "*compilation*")
						 (qsave-search (current-buffer) compile-command)
						 (use-local-map compilation-mode-map)
						 ))