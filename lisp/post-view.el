(put 'post-view 'rcsid 
 "$Id: post-view.el,v 1.4 2003-06-05 19:35:42 cvs Exp $")

;;; use this to get qsave capability on help buffer
;;; should put on post-help, but use post-view instead to make sure keymap gets set correctly

(require 'qsave)
(require 'view) ; this is probably not necessary.

(defun prune-help (n) (interactive "nprune to: ")
  (toggle-read-only -1)
  (prune-search n  (get-buffer "*Help*"))
  (toggle-read-only 1))

(defvar post-view-hook nil "hook to run after view mode.  mostly for help history")
(defun save-help-history () (interactive) (qsave-search (get-buffer "*Help*") (cadr item)))

(define-key view-mode-map "p" 'roll-qsave)
(define-key view-mode-map "n" 'roll-qsave-1)

(define-key view-mode-map "x" 'prune-help)

(add-hook 'post-view-hook 'save-help-history)

(defadvice help-setup-xref (around 
			    hook-help
			    first activate)
  ""
  (run-hooks 'post-view-hook)
  ad-do-it
  )

; (ad-unadvise 'help-setup-xref)
