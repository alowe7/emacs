(put 'kill 'rcsid
 "$Id: kill.el,v 1.7 2006-03-03 20:24:26 alowe Exp $")

(defun yank-like (pat)
  "search for PAT among kill ring, rolling through hits, inserting selected.
see `roll-list` for roll navigation"
  (interactive "spat: ")
  (let ((l (roll-list (loop for x in kill-ring when (string-match pat x) collect x))))
    (if (null l) (message "pat '%s' not found in kill-ring" pat)
      (insert l)
      )
    )
  )
(global-set-key "" 'yank-like)

(global-set-key "?" '(lambda () (interactive) (message (car kill-ring))))


(defun copy-cwd-as-kill (arg) 
  "apply `kill-new' to `default-directory' with optional ARG, canonify first"
  (interactive "P")
  (let ((s default-directory))
    (and arg (setq s (w32-canonify s)))
    (kill-new s)
    (message s))
  )

(defun copy-filename-as-kill (f) 
  "apply `kill-new' to `default-directory' with optional ARG, canonify first"
  (interactive (list (read-file-name (format "filename (%s): " (buffer-file-name) ))))

  (if f
      (let ((s (w32-canonify f)))
	(kill-new s)
	(message s))
    )
  )

(global-set-key (vector ? ?\C-.) 'copy-cwd-as-kill)
(global-set-key (vector ? ?\C-.) 'copy-filename-as-kill)

(defun copy-buffer-file-name-as-kill (arg) 
  "apply `kill-new' to `buffer-file-name' with optional ARG, canonify first"
  (interactive "P")
  (let ((s (buffer-file-name)))
    (and arg (setq s (w32-canonify s)))
    (kill-new s)
    (message s))
  )

(global-set-key (vector ? ?\C-0) 'copy-buffer-file-name-as-kill)

(provide 'kill)
