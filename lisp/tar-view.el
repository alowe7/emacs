(put 'tar-view 'rcsid 
 "$Id: tar-view.el,v 1.7 2002-12-10 17:22:11 cvs Exp $")
(provide 'tar-view)
(require 'cl)

(defun dired-tar-view () (interactive)
	(tar-view (dired-get-filename)) 
	)

(make-variable-buffer-local 'tar-file)
(defun tar-view (f) (interactive)
	(let* ((b (zap-buffer (format "%s *tar*" f))))

		(call-process "tar" nil b nil "tf"  (unix-canonify f 0))
		(pop-to-buffer b)
		(setq tar-file f)
		(tar-view-mode)
		(not-modified)
		(beginning-of-buffer)
		)
	)


(add-file-association "tar" 'tar-view)

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

