; wet paint

(add-to-list 'auto-mode-alist '("\\.tar.gz" . tarzip-mode))
(defun tarzip-mode ()
  (let* (
	 (s (concat "*" (file-name-nondirectory (buffer-file-name)) "*"))
	 (b (zap-buffer s))
	 )
    (shell-command-on-region (format "tar tzf %s" (unix-canonify (buffer-file-name) 0)) b)
    (display-buffer b)
    )
  )