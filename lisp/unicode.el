;; put this on file load hook, with utf-8 recognition/view only

(defun fix-unicode-file () (interactive)
  (save-excursion
    (goto-char (point-min))
    (if (looking-at "��")
	(progn
	  (delete-char 2)
	  (replace-string " " "")
	  )
      )
    (set-buffer-modified-p nil)
    (setq buffer-read-only t)
    )
  (fix-dos-file)
  )

(defun utf-8-hook () (interactive)
  (save-excursion
    (goto-char (point-min))
;    (debug)
    (if (looking-at "��")
	(fix-unicode-file)))
  )

(add-hook 'find-file-hooks 'utf-8-hook)

(provide 'unicode)
