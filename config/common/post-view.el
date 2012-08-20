(put 'post-view 'rcsid 
 "$Id$")

;;; use this to get qsave capability on help buffer
;;; should put on post-help, but use post-view instead to make sure keymap gets set correctly

(require 'qsave)
(require 'view) ; this is probably not necessary.

(defun prune-help (n) (interactive "nprune to: ")
  (let (buffer-read-only)
    (prune-search n  (get-buffer "*Help*"))
    )
  )

(defvar *this-help-item* nil)
(defadvice help-setup-xref (before hook-help-1 first activate)
""
(setq *this-help-item* item)
)
; (if (ad-is-advised 'help-setup-xref) (ad-unadvise 'help-setup-xref))

(defvar post-view-hook nil "hook to run after view mode.  mostly for help history")
(defun save-help-history ()
  (interactive)
  (let ((b (get-buffer "*Help*")))
    (and (buffer-live-p b)
	 (qsave-search b *this-help-item*)
	 )
    )
  )

(add-hook 'post-view-hook 'save-help-history)

(defadvice help-mode-finish (around 
			    hook-help
			    first activate)
  ""


  (run-hooks 'post-view-hook)

  ad-do-it

  )

; (if (ad-is-advised 'help-mode-finish) (ad-unadvise 'help-mode-finish))

(define-key help-map "\C-w" 'switch-to-help-buffer)
(define-key help-mode-map "p" 'roll-qsave)
(define-key help-mode-map "n" 'roll-qsave-1)

(define-key help-mode-map "x" 'prune-help)

(provide 'post-view)
