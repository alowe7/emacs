(defconst rcs-id "$Id: post-help.el,v 1.1 2000-10-02 21:17:28 cvs Exp $")

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

(define-key  view-mode-map "p" 
  '(lambda () 
     (interactive)
     (previous-qsave-search (current-buffer))))

(define-key  view-mode-map "n" 
  '(lambda ()
     (interactive)
     (next-qsave-search (current-buffer))))

; (ad-unadvise 'help-mode-finish)
