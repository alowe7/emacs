(put 'post-dired 'rcsid 
 "$Id$")

(eval-when-compile (require 'cl))

(setq dired-listing-switches "-alt")

(defun dired-diff-backup () (interactive)
  (diff-backup (dired-get-filename))
  )

(defun diff-marked-files ()
  (interactive)
  (let* ((l (dired-get-marked-files)) 
	 (b
	  (cond ((< (length l) 2) (message "need 2 marked files"))
		((> (length l) 2) (message "too many marked files"))
		(t (apply 'diff l)))))
    (and (bufferp b)
	 (set-buffer b)
	 (diff-mode)
	 (font-lock-mode t))
    )
  )

(defun dired-copy-file-1 () (interactive)
  (let* ((f (dired-get-filename))
		 (to (read-string* "copy %s to: " (file-name-nondirectory f))))

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

(defvar dired-exec-file-type-list nil)

(defun dired-exec-file ()
  (interactive)
  (let* ((f (dired-get-filename))
	 (ext (file-name-extension f))
	 (dispatch (assoc ext  dired-exec-file-type-list)))

    (if dispatch (funcall (cdr dispatch) f)
      (find-file f))
    )
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

(defun dired-canonify-filename (fromstr tostr &optional no-update)
  (interactive (list (string* (read-string (format "replace (%s): " "SPC")) " ")
		     (string* (read-string (format "replace space with char (%s): " "-")) "-")))

  "rename selected file to replace spaces with CHAR (default '-')."

  (let* ((fn (dired-get-filename))
	 (newfn (replace-regexp-in-string fromstr tostr (file-name-nondirectory fn))))

    (if (or 
	 (not (file-exists-p newfn))
	 (y-or-n-p
	  (format "File already exists: %s.  Replace? " newfn)))
	(rename-file fn newfn t))

    )

  (or no-update (revert-buffer))

  )

;(defun dired-move-marked-files (to) (interactive "Ddir: ")
;  (mapcar '(lambda (x) (dired-move-file to x)) (dired-get-marked-files)))

;; yet another way to do this

(defun dired-move-marked-files () (interactive)
  (dired-move-file t t)
  (revert-buffer))

(defun dired-copy-marked-files (to) (interactive "Dcopy marked files to dir: ")
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
  (goto-char (point-min))
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
    (goto-char (point-min))
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
	   (if
	       (y-or-n-p (format "touch %s? " fn)) 
	       (progn
		 (touch-file fn)
		 (message "")
		 (sit-for .100)
		 (revert-buffer)
		 )
	     )
	   )
	 )
	)
  )

(defvar file-assoc-list nil
  "assoc mapping of downcased file extensions to handlers")

(defun add-file-association (type handler)
  "add assoc mapping of downcased file extension to handler.
TYPE is a string sans dot.  HANDLER is a function of one arg to process the file 
see `file-assoc-list'"

  (let ((v (assoc* type file-assoc-list :test 'string=)))
    (and v (setq file-assoc-list (remove* v file-assoc-list)))

    (push
     (cons type handler)
     file-assoc-list))
  )


(defun file-association-1 (f &optional notrim)
  "find command associated with filetype of specified file"
  (interactive "sFile: ")
  (cdr (assoc (file-name-extension f) file-assoc-list))
  )

(defun file-association (f &optional notrim)
  "find command associated with filetype of specified file"
  (interactive "sFile: ")
  (let ((cmd (eval-shell-command (format "plassoc \".%s\"" (file-name-extension f)) )))
    ;; sometimes command line args are appended to cmd.
    ;; we usually want just the executable
    (if cmd 
	(if notrim cmd
	  (car (catlist cmd ?\"))
	  )
      )
    )
  )
; (file-association "foo.doc" t)
; (file-association "foo.el" t)

(defun dired-aexec () (interactive)
  (cond
   ((file-directory-p (dired-get-filename))
    (explore-file (dired-get-filename)))
   (t
    (aexec
     (file-name-nondirectory (dired-get-filename))
     )
    )
   )
  )

(defun dired-cvs-cmd (cmd) (interactive "scmd: ")
  (cvs cmd (format "\"%s\"" (dired-get-filename)))
  )

(defun dired-cvs-log () (interactive)
  (dired-cvs-cmd "log")
  )

(defun dired-cvs-update () (interactive)
  (dired-cvs-cmd "up")
  )

(defun dired-make-backup ()
  "make a backup of `dired-get-filename' using `make-backup-file-name'"
 (interactive)
  (let* ((from (dired-get-filename))
	 (to (make-backup-file-name from)))
    (dired-copy-file from to t)
    (revert-buffer))
  )

(defun dired-sum-diff () (interactive)
  (let* ((f (dired-get-filename))
	 (fn (file-name-nondirectory f))
	 (x (sum f))
	 (y (save-window-excursion (other-window-1) (sum fn))))
    (= x y))
  )

(defun dired-enumerate-scripts (type)
  (interactive (list (completing-read "type: " '(("perl") ("sh")) nil t)))
  (let ((l (perl-command-1 "/usr/local/bin/enumerate-scripts" :args (list "-t" type) :show 'split))
	b )
    (if (interactive-p)
	(progn 
	  (setq b (zap-buffer "*scripts*"))
	  (loop for x in l do (insert x "
")) 
	  (goto-char (point-min))
	  (fb-mode)
	  (switch-to-buffer b)
	  b)
      l)
    )
  )

(unless (fboundp 'ctl-x-v-prefix) 
    (define-prefix-command 'ctl-x-v-prefix))

(unless (and (boundp 'ctl-x-v-map) ctl-x-v-map)
  (setq ctl-x-v-map (symbol-function 'ctl-x-v-prefix)))

(defun kill-dired-filename () 
  (interactive)
  (kill-new (w32-canonify (dired-get-filename)))
  )


; turns out this interacts negatively with clearcase-hook-dired-mode-hook.
(unless (boundp 'clearcase-hook-dired-mode-hook)
  (add-hook 'dired-mode-hook 'turn-on-font-lock))

; todo generesize
(defun dired-yank-filename (&optional arg)
  (interactive "P")
  (funcall (if arg 'yank-dos-filename 'yank-unix-filename)
   (condition-case x
       (dired-get-filename)
     (error default-directory)))
  )

(defun my-dired-rename-file (pat)
  (interactive "spat: ")
  (let ((f (dired-get-filename t)))
    (rename-file f (concat f "." (string* pat "bak")))
    )
  (revert-buffer)
  )

(defun dired-what-file (&optional arg) 
  "apply `kill-new' to `dired-get-filename' with optional ARG, canonify first"
  (interactive "P")

  (let* ((f (or (dired-get-filename nil t) default-directory))
	 (s (if arg (w32-canonify f) f)))
    (kill-new s)
    (and (interactive-p) (message s))
    s
    )
  )

(require 'filetime)
(defun dired-what-filetime ()
  "displays full filetime for indicated file"
  (interactive)
  (kill-new (message (format-time-string "%a %b %d %H:%M:%S %Y" (filemodtime (dired-get-filename)))))
  )

(defun dired-md5-compare ()
  (interactive)
  (eval-process "md5sum " (dired-get-filename))
  )

(defvar dired-mode-syntax-table (copy-syntax-table))
(modify-syntax-entry ?- "w" dired-mode-syntax-table)
(modify-syntax-entry ?. "w" dired-mode-syntax-table)  

(add-hook 'dired-mode-hook 
	  '(lambda nil 
	     (define-key dired-mode-map "t" 'dired-change-file-type)
	     (define-key dired-mode-map "" 'dired-enumerate-scripts)
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

	     (define-key dired-mode-map "e" 'dired-decrypt-find-file)

	     (define-key dired-mode-map (vector 'C-return ? ) 'dired-unmark-all-files)

	     (define-key dired-mode-map "i" 'dired-what-filetime)

	     (define-key dired-mode-map (vector '\C-return ?\C-r) 'dired-rename-file)
	     (define-key dired-mode-map (vector '\C-return ?\C-y) 'dired-yank-filename)

			      (define-key dired-mode-map "\C-m" 'dired-aexec)
  ;			      (define-key dired-mode-map "\C-m" 'dired-exec-file)
			      (define-key  dired-mode-map "P" '(lambda () (interactive) (dos-print (dired-get-filename))))
			      (define-key  dired-mode-map (vector ? ?\C-0) 'kill-dired-filename)
			      (define-key dired-mode-map "|" 'dired-pipe-file)
			      (define-key  dired-mode-map "\C-cw" 'dired-what-file)

			      (define-key  dired-mode-map "\M-~" 'dired-make-backup)

			      (define-key  dired-mode-map "\C-cu" 'dired-zip-extract)

			      (define-key dired-mode-map "\C-xv" 'ctl-x-v-prefix)
			      (define-key dired-mode-map "V" 'dired-html-view)

			      (define-key dired-mode-map (vector 'f4) 'cfo)
			      (define-key dired-mode-map (vector 'f5) 'rfo)


			      (let ((was (lookup-key  dired-mode-map "t")))
				(unless (eq was 'dired-touch-file)
				  (define-key dired-mode-map "T" was)
				  )
				)
			      (define-key dired-mode-map "t" 'dired-touch-file)

  ; see datestamp.el
  ; (define-key dired-mode-map (vector 'C-return ?d) 'mkdatestampdir)

			      (define-key dired-mode-map (vector '\C-return ?\C--) 'dired-canonify-filename)

	     (set-syntax-table dired-mode-syntax-table)  
	     )
	  )

(provide 'post-dired)
