(put 'post-view 'rcsid 
 "$Id: post-view.el,v 1.1 2000-10-10 20:24:50 cvs Exp $")

;;; use this to get qsave capability on help buffer
;;; put on post-view to make sure keymap gets set correctly

(require 'qsave)

(defadvice help-setup-xref (around 
			    hook-help
			    first activate)
  ""
  (qsave-search (get-buffer "*Help*") (cadr item))
  ad-do-it
  )

  (define-key  view-mode-map "p" '(lambda () (interactive) (previous-qsave-search (get-buffer "*Help*"))))
  (define-key  view-mode-map "n" '(lambda () (interactive) (next-qsave-search (get-buffer "*Help*"))))
  (define-key  view-mode-map "x" '(lambda (n) (interactive "nprune to: ")
				    (toggle-read-only -1)
				    (prune-search (get-buffer "*Help*") n)
				    (toggle-read-only 1)))

; (ad-unadvise 'help-setup-xref)
