(put 'sisdir 'rcsid
 "$Id$")

(defvar *sisdirs* nil "alist of related directories to cycle through using `sisdir'")

; 
(defun construct-sisdirs (base)
  " return a list that can be merged into *sisdirs*
"
  (loop
   with l = (get-directory-files base)
   for pat in '("CVS" ".svn") do (setq l (remove* pat l :test 'string=))
   finally return l
   )
  )

; (add-to-list '*sisdirs* (construct-sisdirs "~/emacs/config/hosts"))
; (setq *sisdirs* '(("lt-alowe" "granite")))
; (setq *sisdirs* '(("a" "a.bak")))

(defun ancestors (&optional dir)
  "return list of ancestores of optional directory DIR
if dir is not specified, uses `default-directory '
"
  (loop with d = (canonify (or dir default-directory) 0)
	until (string= d "/")
	collect (setq d (canonify (concat (directory-file-name d) "/..") 0)))
  )
; (assert (equal (ancestors) '("/home/a/emacs" "/home/a" "/home" "/")))

; todo: persist on exit; reinitialize from storage on load
(/*
; default to ~/.sisdirs, but when (featurep 'config), use per host-config
(setq 
 sisdirs-default-file
 (expand-file-name ".sisdirs" (file-name-directory (locate-config-file "host-init")))
 )
*/)

(defvar sisdirs-default-file "~/.sisdirs"  "File in which to save sisdirs by default.")
(defvar sisdirs-already-loaded nil)
(defun sisdirs-maybe-load-default-file (&optional force)
  (and (or force (not sisdirs-already-loaded))
       (file-readable-p sisdirs-default-file)
       (sisdirs-load sisdirs-default-file t t)
       (setq sisdirs-already-loaded t))
  )
; (sisdirs-maybe-load-default-file)
; (sisdirs-maybe-load-default-file t)

(defun sisdirs-save ()
  (interactive)
  (sisdirs-maybe-load-default-file)
  (sisdirs-write-file sisdirs-default-file)
  )
; (call-interactively 'sisdirs-save)

(defun sisdirs-write-file (file)
  "Write `*sisdirs*' to FILE."
  (with-current-buffer (get-buffer-create " *Sisdirs*")
    (goto-char (point-min))
    (delete-region (point-min) (point-max))
    (insert (pp *sisdirs*))
    (condition-case nil
	(write-region (point-min) (point-max) file)
      (file-error (message "Can't write %s" file)))
    (kill-buffer (current-buffer))
    (message
     "Saving sisdirs to file %s...done" file))
  )

(defun sisdirs-load (file &optional overwrite no-msg)
  (interactive
   (list (read-file-name* "Load sisdirs from: (%s) " sisdirs-default-file default-directory ".sisdirs")))

  (if (null no-msg)
      (message "Loading sisdirs from %s..." file))

  (setq *sisdirs* (read (read-file sisdirs-default-file t)))
  )
; (call-interactively 'sisdirs-load)

(defun sisdirs-exit-hook-internal ()
  "Save sisdirs state, if necessary, at Emacs exit time.
"
  (and *sisdirs*
       (sisdirs-save)))

(add-hook 'kill-emacs-hook 'sisdirs-exit-hook-internal)

(defun set-sisdirs-p (&optional dir)
  (interactive)

  (if (y-or-n-p "sisdir for current directory not found.  set one now?")
      (let* (
	     (dir (or dir default-directory))
	     (common-parent
	      (loop for x in (ancestors dir)
		    thereis (and (y-or-n-p (format "use %s as common parent?" x)) x)
		    ))
	     (common-part
	      (and (string-match common-parent dir) (substring dir (1+ (match-end 0)))))
	     (choices
	      (loop with l = (get-directory-files common-parent)
		    for d in  (list ".svn" common-part)
		    do (setq l (remove* d l :test 'string=))
		    finally return l))
	     )
	(debug)
	(add-to-list '*sisdirs* 
		     (list common-part (completing-read* "sister for thing (%s): " choices (car choices)))
		     )
	)
    )
  )
; (set-sisdirs-p "/home/a/emacs/config/hosts/lt-alowe")

(defun sisdir ()
  "switch to buffer in a parallel directory as defined by `*sisdirs*'
if currently visiting a file, search for a file by the same name in the first sister directory
else just dired there
"
  (interactive)

  (sisdirs-maybe-load-default-file)

  (let* ((dir default-directory)
	 (sub
	  (loop for x in *sisdirs* 
		when (string-match (car x) dir)
		return (concat 
			(substring dir 0 (match-beginning 0))
			(cadr x)
			(substring dir (match-end 0) )
			)
		when (string-match (cadr x) dir)
		return (concat 
			(substring dir 0 (match-beginning 0))
			(car x)
			(substring dir (match-end 0) )
			)
		)
	  )
	 (fn (buffer-file-name)))
    (cond
     ((not sub)
      (if (interactive-p) (set-sisdirs-p)))
     (fn
      (let ((other-file (expand-file-name (file-name-nondirectory fn)  sub)))
	(cond ((file-exists-p other-file) (find-file-other-window other-file))
	      ((file-directory-p sub) (dired-other-window sub))
	      (t (message (format "%s does not exist" sub) )))
	))
     (t  (cond ((file-directory-p sub) (dired-other-window sub))
	       (t (message (format "%s does not exist" sub) ))))
     )
    )
  )

(define-key ctl-/-map "" 'sisdir)

(provide 'sisdir)
