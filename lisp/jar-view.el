(put 'jar-view 'rcsid 
 "$Id: jar-view.el,v 1.6 2003-03-26 22:51:20 cvs Exp $")
(provide 'jar-view)
(require 'cl)

(defun dired-jar-view () (interactive)
	(jar-view (dired-get-filename)) 
	)

(defvar jar-command
  (string* (whence "jar") 
	   (if (boundp 'java-home) (concat java-home "/bin/jar")
	     "c:/j2sdk1.4.1_01/bin/jar")))


(make-variable-buffer-local 'jar-file)
(defun jar-view (f) (interactive)
	(let* ((b (zap-buffer (format "%s *jar*" f))))

		(call-process  jar-command nil b nil "-tf"  (unix-canonify f))
		(pop-to-buffer b)
		(setq jar-file f)
		(jar-view-mode)
		(not-modified)
		(beginning-of-buffer)
		)
	)


(add-file-association "jar" 'jar-view)

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
  "visit indicated file inside a jar"
  (interactive)
  (let ((f (bgets)))
    (message f)
    )
  )

