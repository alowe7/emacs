(put 'encrypt 'rcsid 
 "$Id: encrypt.el,v 1.4 2000-10-03 16:50:27 cvs Exp $")
(provide 'encrypt)
(require 'comint) ; for non-echoing read


(defvar decrypt-mode-map nil "")
(defvar *key-program* "key")

(defun encrypt-write-buffer (fn key)
  "write out current buffer encrypted.
this happens even if buffer is not modified.  
backup versions are not kept."
  (interactive (list (read-file-name "encrypt write file: ")
		     (comint-read-noecho "key: " t)))

  (let ((fn (expand-file-name fn)))
    (unless 
	(and 
	 (file-exists-p fn)
	 (not (y-or-n-p (format "file %s exists. overwrite? " fn) )))

      (call-process-region (point-min) (point-max) *key-program*
			   nil 
			   (setq b (get-buffer-create " *sub*"))
			   nil "-k" key "-o" fn "-")

      (unless
	  (message* 
	   (save-excursion 
	     (set-buffer b)
	     (string* (buffer-string))
	     ))
	(set-buffer-modified-p nil)
	)

      (kill-buffer b)
      )
    )
  )

(defun encrypt-save-buffer (key)
  "write out current buffer encrypted.
this happens even if buffer is not modified.  
backup versions are not kept."
  (interactive (list (comint-read-noecho "key: " t)))

  (let*
      ((bfn (buffer-file-name))
       (fn (and bfn (expand-file-name (buffer-file-name))))
       b)
    (if (not fn)
	(encrypt-write-buffer
	 (read-file-name "encrypt save file: ")
	 key)
      (if (file-exists-p fn)
	  (copy-file fn (make-backup-file-name fn) t))
      (call-process-region (point-min) (point-max) *key-program*
			   nil 
			   (setq b (get-buffer-create " *sub*"))
			   nil "-k" key "-o" fn "-")
      (unless
	  (message* 
	   (save-excursion 
	     (set-buffer b)
	     (string* (buffer-string))
	     ))
	(set-buffer-modified-p nil)
	)

      (kill-buffer b)
      )
    )
  )

(defun dired-decrypt-find-file (key)
  " read encrypted file into buffer using specified key"
  (interactive (list (comint-read-noecho "key: " t)))

  (decrypt-find-file (dired-get-filename) key)
  )

(defun decrypt-find-file (fn key)
  " read encrypted file into buffer using specified key"
  (interactive (list (read-file-name "decrypt find file: ")
		     (comint-read-noecho "key: " t)))

  (let ((b (zap-buffer (file-name-nondirectory fn))))
    (call-process *key-program* nil b nil "-d" "-k" key (expand-file-name fn))
    (pop-to-buffer b)
    (beginning-of-buffer)
    (setq buffer-file-name fn)
    (cd (file-name-directory (expand-file-name fn)))
    (auto-save-mode -1)
    (set-buffer-modified-p nil)
    (decrypt-mode)
    )
  )


(defun decrypt-mode ()
  (use-local-map
   (or decrypt-mode-map (prog1
			    (setq decrypt-mode-map (make-sparse-keymap))
			  (define-key decrypt-mode-map "" 'encrypt-save-buffer)
			  )
       )
   )
  (setq mode-name "Decrypt")
  (setq major-mode 'decrypt-mode)
  (setq mode-line-process nil)
  )
