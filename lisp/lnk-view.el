(put 'lnk-view 'rcsid 
 "$Id$")
(require 'cl)

(defvar *shortcut-helper* (executable-find "shortcut"))

(if *shortcut-helper*
    (fset 'read-shortcut
	  `(lambda (b f)
	     " use shortcut
"
	     (call-process ,*shortcut-helper* nil b nil "-t" f "-u" "all"))
	  )

  (defvar *readshortcut-helper* (executable-find "readshortcut"))
  (if *readshortcut-helper*
      (fset 'read-shortcut
	    `(lambda (b f)
	       " use readshortcut
"
	       (call-process ,*readshortcut-helper* nil b nil f)
	       )
	    )
    (error "cannot find shortcut or readshortcut executables")
    )
  )

; (read-shortcut (zap-buffer "foo") "c:/Users/alowe/AppData/Roaming/Microsoft/Windows/Recent/1999 bmw e36 m3.lnk")

(defun dired-lnk-view () (interactive)
	(lnk-view (dired-get-filename)) 
	)

(make-variable-buffer-local 'lnk-file)

(defvar *lnk-view-in-buffer* nil)

(defun lnk-view (f)
  "view the contents of a windows shortcut"
  (interactive "ffile: ")
  (if *lnk-view-in-buffer*
      (let* ((bn (basename f))
	     (f (w32-canonify (expand-file-name f)))
	     (b (zap-buffer (format "%s *lnk*" bn))))

	(read-shortcut b f)
	(switch-to-buffer b)
	(lnk-mode)
	(setq lnk-file f)
	(set-buffer-modified-p nil)
	(goto-char (point-min))
	)
    (message (kill-new (eval-process "readshortcut" f)))
    )
  )

(defvar lnk-mode-map nil "")
(if lnk-mode-map
    ()
  (setq lnk-mode-map (make-sparse-keymap))
  (define-key lnk-mode-map "f" 'lnk-visit-file)
  (define-key lnk-mode-map "d" 'lnk-dired-file)
  )


(defun lnk-mode ()
  "major mode for viewing shortcut files"
  (interactive)
  (kill-all-local-variables)
  (use-local-map lnk-mode-map)
  (setq buffer-read-only t)
  (setq mode-name "LNK")
  (setq major-mode 'lnk-mode)
  )

(defun lnk-visit-file ()
  (interactive)
  (find-file (canonify (target lnk-file) t))
  )

(defun lnk-dired-file ()
  (interactive)
  (dired (canonify (target lnk-file) t))
  )

(defun target (lnk)
  (let ((f (cond ((file-exists-p lnk) lnk)
		 ((file-exists-p (concat lnk ".lnk")) (concat lnk ".lnk")))))
    (query-shortcut f 'Target)))

; (find-file (target "/f.lnk"))

(defun update-shortcut (target name)
  (call-process 
   *shortcut-helper* nil nil nil "-c" "-t" target "-n" name)
  )

(defun query-shortcut (name &optional attr)
  (let ((a (loop
	    for x in (split  (eval-process
			      *shortcut-helper* "-u" "all" "-n" name) "
")
	    collect 
	    (let* ((l (split x ":"))
		   (la (pop l))
		   (lv (join l ":"))
		   )
	      (list (intern la) (trim-white-space lv)))
	    )))
    (if attr (cadr (assoc attr a)) a)
    )
  )

(add-file-association "lnk" 'lnk-view)

(provide 'lnk-view)
