(put 'post-dired 'rcsid 
 "$Id: post-dired.el,v 1.13 2002-06-06 10:54:36 cvs Exp $")

;; dired stuff


(setq dired-listing-switches "-alt")

(defun dired-diff-backup () (interactive)
  (let* ((f (dired-get-filename))
	 (b (concat f "~")))

    (if (file-exists-p b)
	(let ((d (eval-process "diff" f b)))
	  (if (= (length d) 0)
	      (message "no differences")
	    (let ((buf (zap-buffer "*diff*")))
	      (insert d)
	      (pop-to-buffer buf)
	      )))

      (message "no backup for %s" f)
      )
    )
  )


(defun dired-copy-file-1 () (interactive)
  (let* ((f (dired-get-filename))
	 (to (read-file-name
	      (format "copy %s to: " 
		      (file-name-nondirectory f)))))

    (if (file-directory-p to) 
	(setq to (concat to 
			 (if (not (string= (substring to -1) "/")) "/")
			 (file-name-nondirectory f))))

    (and
     (or (not (file-exists-p to))
	 (y-or-n-p (format "file %s exists.  overwrite? " to)))
     (progn (copy-file f to t)
	    (revert-buffer)))))


(defun dired-change-file-type (newtype)
  (interactive "snew file type: ")
  (let* ((f (dired-get-filename)))
    (rename-file f
		 (concat
		  (file-name-sans-extension (dired-get-filename))
		  "." newtype))
    (revert-buffer)))


;;; dired stuff -- see dired helpers

(defun dired-execute-file ()
  (interactive)
  (call-process (dired-get-filename) nil 0)
  )

(defvar last-dired-move-to nil)

(defun dired-move-file (arg &optional no-update)
  (interactive "P")

  "move selected file to specified LOCATION.
LOCATION may be a file or directory.
with prefix arg, move all marked files.
warns if more than one file is to be moved and target is not a directory"

  (let* (fns 
	 newfn
	 (todir (and last-dired-move-to 
		     (file-name-directory last-dired-move-to)))
	 (to
	  (read-file-name 
	   (format "move %s to (%s): " 
		   (if arg 
		       (progn (setq fns (dired-get-marked-files)) "(marked files ...)" )
		     (progn (setq fns (list (dired-get-filename))) 
			    (file-name-nondirectory (dired-get-filename))))
		   (or todir (pwd)))
	   )))

    (unless (> (length to) 0) (setq to todir))

    (if (or (<= (length fns) 1)
	    (file-directory-p to)
	    (y-or-n-p "move multiple files to single target?"))

	(loop 
	 for fn in fns
	 do

	 (setq newfn
	       (if (file-directory-p to)
		   (concat (expand-file-name to)
			   (if (not (eq ?/ (elt to (1- (length to))))) "/")
			   (file-name-nondirectory fn))
		 to))

	 (if (or 
	      (not (file-exists-p newfn))
	      (y-or-n-p
	       (format "File already exists: %s.  Replace? " newfn)))
	     (rename-file fn newfn t))

	 )
      )

    (setq last-dired-move-to to)
    (or no-update (revert-buffer))
    )
  )

;(defun dired-move-marked-files (to) (interactive "Ddir: ")
;  (mapcar '(lambda (x) (dired-move-file to x)) (dired-get-marked-files)))

;; yet another way to do this

(defun dired-move-marked-files () (interactive)
  (dired-move-file t t)
  (revert-buffer))

(defun dired-copy-marked-files (to) (interactive "Ddir: ")
  (loop for x in  (dired-get-marked-files)
	do
	(let ((tof (if (file-directory-p to)
		       (concat to
			       (if (not (equal (substring to -1) "/")) "/" )
			       (file-name-nondirectory x))
		     to)))
	  (and (or (not (file-exists-p tof))
		   (y-or-n-p (format "File %s exists.  Replace? " tof)))
	       (copy-file x tof t))
	  ))
  )

(defun dired-pipe-file (command)
  (interactive "scommand: ")
  (call-process command 
		(file-name-nondirectory (dired-get-filename))
		(zap-buffer "*Dired Process Output*"))
  (pop-to-buffer "*Dired Process Output*")
  (beginning-of-buffer)
  )

(defun dired-gs-file ()
  (interactive)
  (let* ((f (dired-get-filename))
	 (b (get-buffer-create "*gs*")))
    (start-process "gs-process" b "gs" f)
    )
  )

(defun dired-gunzip-file (&optional arg)
  "unzip specified file & suck results into a buffer"
  (interactive "P")
  (let* ((f (dired-get-filename))
	 (b (zap-buffer  (file-name-nondirectory f))))
    (call-process "gzcat" f  b t)
    (if arg (switch-to-buffer-other-window b)
      (switch-to-buffer b))
    (browse-mode)
    (beginning-of-buffer)
    (set-buffer-modified-p nil)
    )
  )

(defun dired-touch-file (&optional arg)
  "touch indicated file"
  (interactive "P")
  (cond ((and arg (dired-get-marked-files))
	 (if (y-or-n-p "touch marked files? ")
	     (loop for fn in (dired-get-marked-files) 
		   do (touch-file fn)
		   finally (revert-buffer)))
	 )
	(arg (message "no marked files"))
	(t
	 (let ((buffer-read-only nil)
	       (fn (dired-get-filename)))
	   (and (y-or-n-p (format "touch %s? " fn)) (touch-file fn)
		(dired-redisplay fn) (message ""))
	   )
	 )
	)
  )

(defun execute-indicated-file ()
  (interactive)
  (let ((cmd  (indicated-word))
	(buffer (get-buffer-create "*output*")))
    (save-excursion
      (set-buffer buffer)
      (auto-save-mode 0)
      (end-of-buffer)
      (insert (concat cmd "
"))
      (call-process cmd nil t nil)
      )
    )
  )

(defvar dired-mode-syntax-table (copy-syntax-table))
(modify-syntax-entry ?- "w" dired-mode-syntax-table)
(modify-syntax-entry ?. "w" dired-mode-syntax-table)  

(add-hook 'dired-mode-hook 
	  '(lambda nil 
	     (define-key dired-mode-map "t" 'dired-change-file-type)
	     (define-key  dired-mode-map "b" '(lambda () (interactive)
						(find-file-binary (dired-get-filename))))
	     (define-key  dired-mode-map "I" '(lambda () (interactive)
						(info (dired-get-filename))))
	     (define-key dired-mode-map "r" 'dired-move-file)
	     (define-key dired-mode-map "t" 'dired-touch-file)
	     (define-key dired-mode-map "c" 'dired-copy-file-1)
	     (define-key dired-mode-map "%~" 'dired-diff-backup)
	     (define-key dired-mode-map "%M" 'dired-move-marked-files)
	     (define-key dired-mode-map "%t" 'dired-change-file-type)
	     (define-key dired-mode-map "%%" '(lambda (beg end) (interactive "r") (dired-mark-files-in-region beg end)))
	     (define-key dired-mode-map "%x" '(lambda (beg end) (interactive "r") (dired-mark-files-in-region beg end) (mapcar 'delete-file (dired-get-marked-files))))

	     (set-syntax-table dired-mode-syntax-table)  
	     )
	  )

(autoload 'dired-tar-view "tar-view")
(autoload 'dired-zip-view "zip-view")
(autoload 'dired-html-view "html-view")

(define-key dired-mode-map "e" 'dired-decrypt-find-file)

(define-key dired-mode-map (vector 'C-return ? ) 'dired-unmark-all-files)

(defvar file-assoc-list nil
  "assoc mapping of downcased file extensions to handlers")

(defun add-file-association (type handler)
  "add assoc mapping of downcased file extension to handler.
see `file-assoc-list'"
  (or (assoc type file-assoc-list)
      (push
       (cons type handler)
       file-assoc-list))
  )

(defun file-association (f &optional notrim)
  "find command associated with filetype of specified file"
  (interactive "sFile: ")
  (let ((cmd (perl-command "plassoc" (concat "." (file-name-extension f)) )))
    ;; sometimes command line args are appended to ocmd.
    ;; we usually want just the executable
    (if cmd 
	(if notrim cmd
	  (car (catlist cmd ?\"))
	  )
      )
    )
  )

(defun dired-aexec () (interactive)
  (aexec (dired-get-filename)))

(defun dired-cvs-log () (interactive)
  (cvs "log" (format "-h %s" (dired-get-filename)))
  )

(defun dired-copy-filename-as-kill (arg) (interactive "P")
  (let ((s (dired-get-filename)))
    (and arg (setq s (w32-canonify s)))
    (kill-new s)
    (message s))
  )

(defun dired-make-backup () (interactive)
  (let* ((from (dired-get-filename))
	 (to (make-backup-file-name from)))
    (dired-copy-file from to t)
    (revert-buffer))
  )

(require 'tar-view)
(require 'zip-view)
(require 'html-view)
(require 'dired-advice)

(add-hook 'dired-mode-hook '(lambda () 
			      (define-key  dired-mode-map "\C-m" 'dired-aexec)
			      (define-key  dired-mode-map "P" '(lambda () (interactive) (dos-print (dired-get-filename))))
			      (define-key  dired-mode-map "" '(lambda () (interactive) (kill-new (w32-canonify (dired-get-filename)))))
			      (define-key dired-mode-map "|" 'dired-pipe-file)
			      (define-key dired-mode-map "\C-xvl" 'dired-cvs-log)
			      (define-key  dired-mode-map "\C-cx" 'dired-copy-filename-as-kill)
			      (define-key  dired-mode-map "\M-~" 'dired-make-backup)

			      (define-key  dired-mode-map "\C-cu" 'dired-zip-extract)
			      ))
