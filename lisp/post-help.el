(put 'post-help 'rcsid 
 "$Id: post-help.el,v 1.5 2003-06-05 19:35:42 cvs Exp $")

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

; (ad-unadvise 'help-mode-finish)
