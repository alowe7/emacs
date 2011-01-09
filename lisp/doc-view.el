(put 'doc-view 'rcsid 
 "$Id$")

(add-to-list 'auto-mode-alist '("\\.doc\\'" . no-word))

(defun no-word ()
  "Run antiword on the entire buffer."
  (if (string-match "Microsoft Office Document"
		    (shell-command-to-string (concat "file " buffer-file-name)))
      (shell-command-on-region (point-min) (point-max) "antiword - " t t)))

(defun doc-view (&optional fn) 
  "view specified file or buffer as word doc"
  (interactive)
  (let* ((fn (or fn (buffer-file-name)))
	 (b (zap-buffer (format "%s *doc* " (file-name-sans-extension fn))))
	 (s (call-process "antiword" nil t nil fn))
	 )
    (pop-to-buffer b)
    (insert s)
    (goto-char (point-min))
    (set-buffer-modified-p nil)
    (view-mode)
    )
  )

(add-file-association "doc" 'doc-view)
; (doc-view "/u/antiword-0.35/Docs/testdoc.doc")

(provide 'doc-view)
