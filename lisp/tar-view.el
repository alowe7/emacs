(put 'tar-view 'rcsid 
 "$Id: tar-view.el,v 1.11 2005-06-17 00:30:00 cvs Exp $")

(require 'cl)

(defun dired-tar-view () (interactive)
	(tar-view (dired-get-filename)) 
	)

(make-variable-buffer-local 'tar-file)
(defun tar-view (f) (interactive)
	(let* ((b (zap-buffer (format "%s *tar*" f))))

		(call-process "tar" nil b nil "tf"  (canonify f 0))
		(pop-to-buffer b)
		(setq tar-file f)
		(tar-view-mode)
		(set-buffer-modified-p nil)
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



(defun tgz-view (f) (interactive)
  (let ((b (zap-buffer (format "%s *tar*" f)))
	(d (file-name-directory f)))
    (call-process "tar" nil b nil "tzf"  (canonify f 0))
    (pop-to-buffer b)
    (setq tar-file f)
    (tar-view-mode)
    (set-buffer-modified-p nil)
    (cd-absolute (expand-file-name (file-name-directory f)))
    (beginning-of-buffer)
    )
  )


(add-file-association "tgz" 'tgz-view)

(defun gz-view (f) (interactive)
  (let ((subf (progn (string-match ".gz$" f) (substring f 0 (match-beginning 0)))))
    (if (string= (file-name-extension subf) "tar")
  ; special case: its a .tar.gz file
	(funcall (file-association-1 ".tgz") f)
      (let ((subfp (file-association-1 subf)))
  ; something-else.gz
	(let* ((b (zap-buffer (format "%s *gz*" f))))
	  (cd-absolute (expand-file-name (file-name-directory f)))
	  (call-process "gunzip" nil b nil "-dc"  (canonify f 0))
	  (pop-to-buffer b)
	  (fundamental-mode)
	  (set-buffer-modified-p nil)
	  (beginning-of-buffer)
	  )
	)
      )
    )
  )


(add-file-association "gz" 'gz-view)

(provide 'tar-view)
