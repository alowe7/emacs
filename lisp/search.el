(put 'search 'rcsid 
 "$Id: search.el,v 1.3 2000-10-03 16:50:29 cvs Exp $")

(defvar search-last-string "" "\
Last string search for by a non-regexp search command.
This does not include direct calls to the primitive search functions,
and does not include searches that are aborted.")


(defun current-word-search-forward () 
  (interactive)
  (forward-word 1)
  (backward-word 1)
  ;; push ont search-ring for emacs19
  (push 
   (setq search-last-string
	 (buffer-substring (point) (progn (forward-word 1) (point))))
   search-ring)
  (or (search-forward search-last-string nil t)
      (message "\"%s\" not found" search-last-string))
  (backward-word 1))

(defun current-word-search-backward ()
  (interactive)
  (forward-word 1) 
  (setq search-last-string
	(buffer-substring (point) (progn (backward-word 1) 
					 (point))))
  (or (search-backward search-last-string nil t)
      (message "\"%s\" not found" search-last-string)))




(defun isearch-region () 
  (interactive)
  (setq search-last-string (buffer-substring (point) (mark)))
  (call-interactively 'isearch-forward t)
  )
