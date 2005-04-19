(put 'lnk-view 'rcsid 
 "$Id: lnk-view.el,v 1.9 2005-04-19 00:20:45 cvs Exp $")
(require 'cl)

(defun dired-lnk-view () (interactive)
	(lnk-view (dired-get-filename)) 
	)

(make-variable-buffer-local 'lnk-file)
(defun lnk-view (f)
  "view the contents of a windows shortcut"
  (interactive)
  (let* ((b (zap-buffer (format "%s *lnk*" f))))

    (call-process "shortcut" nil b nil "-t" f "-u" "all")
    (switch-to-buffer b)
    (lnk-mode)
    (setq lnk-file f)
    (set-buffer-modified-p nil)
    (beginning-of-buffer)
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
   "shortcut" nil nil nil "-c" "-t" target "-n" name)
  )

(defun query-shortcut (name &optional attr)
  (let ((a (loop
	    for x in (split  (eval-process
			      "shortcut" "-u" "all" "-n" name) "
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
