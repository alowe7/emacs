;; put this on file load hook, with utf-8 recognition/view only

(defun fix-unicode-file () (interactive)
  (save-excursion
    (goto-char (point-min))
    (if (looking-at "��")
	(progn
	  (delete-char 2)
	  (while (not (eobp))
	    (forward-char 1)
	    (delete-char 1))
	  (set-buffer-modified-p nil)
	  (setq buffer-read-only t)
	  (auto-save-mode -1)
	  (add-hook 'local-write-file-hooks '(lambda () (message "cannot edit unicode file") t))
	  )
      )
    )
  )

(defun utf-8-hook () (interactive)
  (save-excursion
    (goto-char (point-min))
    (if (looking-at "��")
	(fix-unicode-file)))
  )

(add-hook 'find-file-hooks 'utf-8-hook)

(defun dired-find-unicode-file ()
  (interactive)
  (let ((find-file-hooks (remove* 'utf-8-hook find-file-hooks)))
    (find-file (dired-get-filename))
    )
  )

(add-hook 'dired-mode-hook 
	  '(lambda nil 
	     (define-key  dired-mode-map "F" 'dired-find-unicode-file)
	     ))


(provide 'unicode)
