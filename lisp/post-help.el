(put 'post-help 'rcsid 
 "$Id: post-help.el,v 1.6 2003-09-23 16:01:43 cvs Exp $")

;; see post-view.el

(defvar *advise-help-mode-finish*  nil)

(if *advise-help-mode-finish*
    (progn
      (require 'view)
      (require 'advice)
      (require 'qsave)

      ;; these functions add qsave capability to help buffer

      (defadvice help-mode-finish (after 
				   hook-help-mode-finish
				   first 
				   nil
				   activate)
	(qsave-search (current-buffer) (indicated-word))
	)

      (define-key  view-mode-map "p" 'roll-qsave)
      (define-key  view-mode-map "n" 'roll-qsave-1)

  ; (if (ad-is-advised 'help-mode-finish) (ad-unadvise 'help-mode-finish))
      )
  )
