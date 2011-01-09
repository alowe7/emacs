(put 'encrypt 'rcsid 
 "$Id$")
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
	  (message
	   (with-current-buffer b
	     (string* (buffer-string))
	     )
	   )
	(set-buffer-modified-p nil)
	)

      (kill-buffer b)
      )
    )
  )

(defvar *enable-fast-save-key* t "if set, allow cache of key on buffer local var")

(defvar *fast-save-key* nil)
(make-variable-buffer-local '*fast-save-key*)

(defun encrypt-save-buffer (key)
  "write out current buffer encrypted.
this happens even if buffer is not modified.  
backup versions are not kept."
  (interactive (list (comint-read-noecho "key: " t)))

  (let*
      ((bfn (buffer-file-name))
       (fn (and bfn (expand-file-name (buffer-file-name))))
       (key (string* key (and  *enable-fast-save-key* *fast-save-key*)))
       b)

    ;;    (unless (string* key)
    ;;      (message "please specify a key")

    (let ((oldkey (get (intern (buffer-name)) 'key)))
      (if (or (not (string* oldkey))
	      (string= oldkey key)
	      (y-or-n-p (format "new key (%s) doesn't match old key (%s).  are you sure?"
				(make-string (length key) ?*)
				(make-string (length oldkey) ?*)))
	      (progn (message "") nil)
	      )

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
		(message
		 (with-current-buffer  b
		   (string* (buffer-string))
		   ))
	      (set-buffer-modified-p nil)
	      )

	    (kill-buffer b)
	    )
	)
      )

    ;;      (and *enable-fast-save-key*
    ;;	   (setq *fast-save-key* key))
    )
  ;;    )
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
  (let ((b (create-file-buffer fn)))
    (call-process *key-program* nil b nil "-d" "-k" key (expand-file-name fn))
    (switch-to-buffer b)
    (goto-char (point-min))
    (setq buffer-file-name fn)
    (cd (file-name-directory (expand-file-name fn)))
    (auto-save-mode -1)
    (set-buffer-modified-p nil)
    (decrypt-mode)
    (put (intern (buffer-name)) 'key key)
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

