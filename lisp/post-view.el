(put 'post-view 'rcsid 
 "$Id: post-view.el,v 1.3 2001-04-27 11:38:00 cvs Exp $")

;;; use this to get qsave capability on help buffer
;;; should put on post-help, but use post-view instead to make sure keymap gets set correctly

(require 'qsave)
(require 'view) ; this is probably not necessary.

(defun previous-help () (interactive) (previous-qsave-search (get-buffer "*Help*")))
(defun next-help () (interactive) (next-qsave-search (get-buffer "*Help*")))
(defun prune-help (n) (interactive "nprune to: ")
  (toggle-read-only -1)
  (prune-search n  (get-buffer "*Help*"))
  (toggle-read-only 1))

(defvar post-view-hook nil "hook to run after view mode.  mostly for help history")
(defun save-help-history () (interactive) (qsave-search (get-buffer "*Help*") (cadr item)))

(define-key view-mode-map "p" 'previous-help)
(define-key view-mode-map "n" 'next-help)
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
