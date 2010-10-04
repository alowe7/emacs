;; 
;; $Id$

;; mode to 
(add-to-list 'auto-mode-alist '("\\.lnk" . lnk-mode))
(add-to-list 'auto-mode-alist '("\\.LNK" . lnk-mode))

(defun lnk-mode () (interactive)
  (run-hooks 'lnk-mode-hook)
  (debug)
  )

;; if you drop a windows lnk file into emacs, this hook redirects to the link target
(setq lnk-mode-hook '(lambda () 
		       (let ((b (current-buffer))
			     (f (expand-file-name (cadr (split (clean-string (eval-process "shortcut" "-u" "t" (buffer-file-name))))))))
			 (if (file-exists-p f)
			     (find-file f)
			   (kill-buffer b))))
      )
