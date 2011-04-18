(put 'post-view 'rcsid 
 "$Id$")

;;; use this to get qsave capability on help buffer
;;; should put on post-help, but use post-view instead to make sure keymap gets set correctly

(require 'qsave)
(require 'view) ; this is probably not necessary.

(defun prune-help (n) (interactive "nprune to: ")
  (toggle-read-only -1)
  (prune-search n  (get-buffer "*Help*"))
  (toggle-read-only 1))

(defvar post-view-hook nil "hook to run after view mode.  mostly for help history")
(defun save-help-history ()
  (interactive)
  (let ((b (get-buffer "*Help*")))
    (and (buffer-live-p b)
	 (qsave-search b (cadr item))
	 )
    )
  )

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

; (if (ad-is-advised 'help-setup-xref) (ad-unadvise 'help-setup-xref))

(define-key help-map "\C-w" 'switch-to-help-buffer)

(provide 'post-view)
