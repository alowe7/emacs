(defconst rcs-id "$Id: tar-view.el,v 1.2 2000-07-30 21:07:48 andy Exp $")
(provide 'tar-view)
(require 'cl)

(defun dired-tar-view () (interactive)
	(tar-view (dired-get-filename)) 
	)

(make-variable-buffer-local 'tar-file)
(defun tar-view (f) (interactive)
	(let* ((b (zap-buffer (format "%s *tar*" f))))

		(call-process "tar" nil b nil "tf"  (unix-canonify f))
		(pop-to-buffer b)
		(setq tar-file f)
		(tar-view-mode)
		(not-modified)
		(beginning-of-buffer)
		)
	)


(or (assoc "tar"  file-assoc-list)
		(push
		 '("tar" . tar-view)
		 file-assoc-list))


(defvar tar-mode-map nil "")
(if tar-mode-map
    ()
  (setq tar-mode-map (make-sparse-keymap))
  (define-key tar-mode-map "f" 'tar-visit-file)
	)


(defun tar-view-mode ()
  "major mode for viewing tar files"
  (interactive)
  (kill-all-local-variables)
  (use-local-map tar-mode-map)
  (setq mode-name "TAR")
  (setq major-mode 'tar-mode)
  )

(defun tar-visit-file ()
  (interactive)
  (let ((f (bgets)))
    (message f)
    )
  )

