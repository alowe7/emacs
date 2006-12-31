(put 'unicode 'rcsid
 "$Id: unicode.el,v 1.7 2006-12-31 22:56:38 noah Exp $")

(defvar *unicode-signatures* (list
			      (vector 2303 2302 )
			      "Ã¿Ã¾"
			      "ÿþ"))

(defun is-utf8-p ()
  " determine if current buffer is utf8 encoded by looking at the signature
not sure why different versions require either `*unicode-signature*' or `*alternate-unicode-signature*'
"
  (loop for x in  *unicode-signatures* thereis
	(save-excursion
	  (goto-char (point-min))
	  (condition-case x 
	      (looking-at x) 
	    (wrong-type-argument nil))))
  )

(defun utf8-hook () (interactive)
  (if (is-utf8-p)
      (fix-unicode-file))
  )

(add-hook 'find-file-hooks 'utf8-hook)

;; put this on file load hook, with utf8 recognition/view only

(defun fix-unicode-file () (interactive)
  (save-excursion
    (if (is-utf8-p)
	(progn
	  (goto-char (point-min))
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

(defun dired-find-unicode-file ()
  (interactive)
  (let ((find-file-hooks (remove* 'utf8-hook find-file-hooks)))
    (find-file (dired-get-filename))
    )
  )

(add-hook 'dired-mode-hook 
	  '(lambda nil 
	     (define-key  dired-mode-map "F" 'dired-find-unicode-file)
	     ))


(provide 'unicode)
