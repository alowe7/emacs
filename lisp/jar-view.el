(put 'jar-view 'rcsid 
 "$Id: jar-view.el,v 1.2 2001-04-27 11:38:00 cvs Exp $")
(provide 'jar-view)
(require 'cl)

(defun dired-jar-view () (interactive)
	(jar-view (dired-get-filename)) 
	)

(make-variable-buffer-local 'jar-file)
(defun jar-view (f) (interactive)
	(let* ((b (zap-buffer (format "%s *jar*" f))))

		(call-process "jar" nil b nil "-tf"  (unix-canonify f t))
		(pop-to-buffer b)
		(setq jar-file f)
		(jar-view-mode)
		(not-modified)
		(beginning-of-buffer)
		)
	)


(or (assoc "jar"  file-assoc-list)
		(push
		 '("jar" . jar-view)
		 file-assoc-list))


(defvar jar-mode-map nil "")
(if jar-mode-map
    ()
  (setq jar-mode-map (make-sparse-keymap))
  (define-key jar-mode-map "f" 'jar-visit-file)
	)


(defun jar-view-mode ()
  "major mode for viewing jar files"
  (interactive)
  (kill-all-local-variables)
  (use-local-map jar-mode-map)
  (setq mode-name "JAR")
  (setq major-mode 'jar-mode)
  )

(defun jar-visit-file ()
  (interactive)
  (let ((f (bgets)))
    (message f)
    )
  )

