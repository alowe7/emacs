(put 'jar-view 'rcsid 
 "$Id$")

(require 'cl)

(defun dired-jar-view () (interactive)
	(jar-view (dired-get-filename)) 
	)

(defvar java-home (getenv "JAVA_HOME"))
(defvar jar-command
  (string* (executable-find "jar") 
	   (and (file-directory-p java-home) 
		(expand-file-name "bin/jar" java-home))))
(assert (file-executable-p jar-command) nil  "jar command not found.  java-home:  %s!" java-home)


(make-variable-buffer-local 'jar-file)
(defun jar-view (f) (interactive)
	(let* ((b (zap-buffer (format "%s *jar*" f))))

		(call-process  jar-command nil b nil "-tf"  (canonify f))
		(pop-to-buffer b)
		(setq jar-file f)
		(jar-view-mode)
		(set-buffer-modified-p nil)
		(goto-char (point-min))
		)
	)


(add-file-association "jar" 'jar-view)
(add-file-association "war" 'jar-view)

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

(provide 'jar-view)
