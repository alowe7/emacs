(put 'unicode 'rcsid
 "$Id: unicode.el,v 1.6 2006-12-27 20:12:03 tombstone Exp $")

(defvar *unicode-signature* (vector 2303 2302 ))  ;  
(defvar *alternate-unicode-signature* "ÿþ")

;; put this on file load hook, with utf-8 recognition/view only

(defun fix-unicode-file () (interactive)
  (save-excursion
    (goto-char (point-min))
    (if (looking-at *unicode-signature*)
	(progn
	  (delete-char 2)
	  (while (not (eobp))
	    (forward-char 1)
	    (delete-char 1))
	  (set-buffer-modified-p nil)
	  (setq buffer-read-only t)
	  (auto-save-mode -1)
	  (add-hook 'local-write-file-hooks '(lambda () (message "cannot edit unicode file") t))
	  )
      )
    )
  )

(defun is-utf-8-p ()
  " determine if current buffer is utf-8 encoded by looking at the signature
not sure why different versions require either `*unicode-signature*' or `*alternate-unicode-signature*'
"
  (save-excursion
    (goto-char (point-min))
    (condition-case x 
	(looking-at *unicode-signature*) 
      (wrong-type-argument 
       (condition-case x2 (looking-at  *alternate-unicode-signature*) (error (debug)))))
    )
  )

(defun utf-8-hook () (interactive)
  (if (is-utf-8-p)
      (fix-unicode-file))
  )

(add-hook 'find-file-hooks 'utf-8-hook)

(defun dired-find-unicode-file ()
  (interactive)
  (let ((find-file-hooks (remove* 'utf-8-hook find-file-hooks)))
    (find-file (dired-get-filename))
    )
  )

(add-hook 'dired-mode-hook 
	  '(lambda nil 
	     (define-key  dired-mode-map "F" 'dired-find-unicode-file)
	     ))


(provide 'unicode)
