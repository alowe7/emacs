(put 'shortcut-view 'rcsid "$Id: shortcut-view.el,v 1.4 2000-10-03 16:44:08 cvs Exp $")
(require 'cl)

(defun dired-shortcut-view () (interactive)
	(shortcut-view (dired-get-filename)) 
	)

(make-variable-buffer-local 'shortcut-file)
(defun shortcut-view (f) (interactive)
	(let* ((b (zap-buffer (format "%s *shortcut*" f))))

		(call-process "shortcut" nil b nil "-t" f "-u" "all")
		(pop-to-buffer b)
		(setq shortcut-file f)
		(shortcut-view-mode)
		(not-modified)
		(beginning-of-buffer)
		)
	)


(or (assoc "lnk"  file-assoc-list)
		(push
		 '("lnk" . shortcut-view)
		 file-assoc-list))


(defvar shortcut-mode-map nil "")
(if shortcut-mode-map
    ()
  (setq shortcut-mode-map (make-sparse-keymap))
  (define-key shortcut-mode-map "f" 'shortcut-visit-file)
	)


(defun shortcut-view-mode ()
  "major mode for viewing shortcut files"
  (interactive)
  (kill-all-local-variables)
  (use-local-map shortcut-mode-map)
  (setq mode-name "SHORTCUT")
  (setq major-mode 'shortcut-mode)
  )

(defun shortcut-visit-file ()
  (interactive)
  (let ((f (bgets)))
    (message f)
    )
  )
