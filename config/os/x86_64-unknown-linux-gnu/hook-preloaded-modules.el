; execute post hooks for any preloaded modules.  too late for pre hooks...

(defvar hookdir  "~/emacs/lisp")

; enumerate hooked modules
(defvar hooked-modules 
  (loop for x in (directory-files hookdir nil "post-")
	unless (string-match "^\\.$" x)
	when (string-match "\\(post-\\)\\([a-z\-]+\\)\\(\\.el\\)" x)
	collect (substring x (match-beginning 2) (match-end 2)))
  )

; make sure load-history is correct
(unless (loop for x in load-history
	      thereis (string-match (concat "fns-" emacs-version) (car x)))
  (load
   (format "/usr/lib/emacs/%s.%s/%s/fns-%s" emacs-major-version emacs-minor-version system-configuration emacs-version)))

(loop for module in hooked-modules
      do
      (loop for x in load-history
	    when (string-equal module (car x))
	    do
	    (and *debug-post-load-hook* (debug))
	    (load (concat "post-" module) t t)
	    (setq hooked-functions (remove module hooked-modules))
	    )
)
