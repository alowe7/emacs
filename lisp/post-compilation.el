(put 'post-compilation 'rcsid 
 "$Id: post-compilation.el,v 1.5 2000-10-03 16:50:28 cvs Exp $")

(add-hook 'compilation-completion-hook
					'(lambda () 
						 (set-buffer "*compilation*")
						 (qsave-search (current-buffer) compile-command)
						 (use-local-map compilation-mode-map)
						 ))