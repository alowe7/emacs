(put 'post-compilation 'rcsid 
 "$Id: post-compilation.el,v 1.6 2001-03-19 10:41:53 cvs Exp $")

(add-hook 'compilation-completion-hook
	  '(lambda () 
	     (set-buffer "*compilation*")
	     (qsave-search (current-buffer) compile-command)
	     (use-local-map compilation-mode-map)
	     ))

(defadvice compile (around 
		    hook-compile
		    first activate)
  ""

  ad-do-it
  (run-hooks 'compilation-completion-hook)
  )

; (ad-is-advised 'compile)
; (ad-unadvise 'compile)