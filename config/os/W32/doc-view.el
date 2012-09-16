(put 'doc-view 'rcsid 
 "$Id: doc-view.el 1043 2012-02-22 16:25:27Z alowe $")

(add-to-list 'auto-mode-alist '("\\.doc\\'" . no-word))

(defvar *word-doc-handler* "/usr/local/lib/antiword-0.37/antiword.exe")

(defun no-word ()
  "Run antiword on the entire buffer."
  (if (string-match "Microsoft Office Document"
		    (shell-command-to-string (concat "file " buffer-file-name)))
      (shell-command-on-region (point-min) (point-max) (format "%s - " *word-doc-handler*) t t))
  )

(defun doc-view (&optional fn) 
  "view specified file or buffer as word doc"
  (interactive)
  (let* ((fn (or fn (buffer-file-name)))
	 (b (zap-buffer (format "%s *doc* " (file-name-sans-extension fn))))
	 (s (call-process *word-doc-handler* nil t nil fn))
	 )
    (pop-to-buffer b)
    (insert s)
    (goto-char (point-min))
    (set-buffer-modified-p nil)
    (view-mode)
    )
  )

(add-file-association "doc" 'doc-view)

(provide 'doc-view)
