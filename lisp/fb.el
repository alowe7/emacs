(put 'fb 'rcsid 
 "$Id: fb.el,v 1.27 2002-03-05 06:10:13 cvs Exp $")
(require 'view)
(require 'isearch)
(require 'cat-utils)
(require 'qsave)


(defvar fb-mode-map nil "")
(defvar fb-mode-syntax-table nil "")
(defvar fb-mode-hook nil)
(defvar fb-last-pat nil)
(defvar fb-last-match nil)

(defvar *fastfind-buffer* "*ff*")

(defconst *default-fb-db* 
  (or (getenv "FBDB")
      "/var/spool/f")
  "cache of working file list.")

(defvar *fb-db* 
  (or (getenv "FBDB")
      "/var/spool/f")
  "cache of working file list.")

(defconst *fb-h-db* 
  (or (getenv "FBHDB")
      "/var/spool/fh")
  "cache of file list on home drive.")

(defconst *fb-full-db*
  (or (getenv "FBFULLDB")
      "/var/spool/fall")
  "cache of file list all drives")

;; these add qsave capability to fb-search buffer
(defvar *find-file-query* nil)
(defun find-file-save-search ()
  (qsave-search (current-buffer) *find-file-query* default-directory)
  )

(defvar after-find-file-hook nil)
(add-hook 'after-find-file-hook 'find-file-save-search)

(defun fb-match-file (pat &optional direction)
  "find file matching PAT in optional DIRECTION"
  (if (> (length pat) 0) 
      (setq fb-last-match nil
	    fb-last-pat (replace-in-string "*" "[^\n]*" pat)))
  (fb-search nil direction)
  )

(defun fb-match-file-forward (pat) 	
  (interactive 
   (list	(read-string (format "pat (%s): " fb-last-pat))))
  (fb-match-file pat)
  )

(defun fb-match-file-backward (pat) 	
  (interactive "spat: ")
  (fb-match-file pat t)
  )

(defun fb-search (spat &optional backwards)

  (and spat (setq fb-last-match nil
		  fb-last-pat spat))

  (if (and (not backwards)
	   fb-last-match
	   (eq (point) (car fb-last-match)))
      (goto-char (cdr fb-last-match)))
 
  (let ((pat (if (> (length spat) 0) spat fb-last-pat))
	(search (if backwards 're-search-backward 're-search-forward))
	(bound  (if backwards 'match-end 'match-beginning)))

    (if (funcall search pat nil t)
	(setq fb-last-match (cons (match-beginning 0)  (match-end 0)))
      (progn
	(setq fb-last-match nil)
	(message "%s not found."  pat))
      )
    )
  )

(defun fb-indicated-file ()
  (trim-white-space (indicated-word))
  )

(defun fb-dired-file ()
  (interactive)
  (dired (fb-indicated-file))
  )

(defun fb-delete-file ()
  (interactive)
  (let ((f (fb-indicated-file)))
    (unless (not (y-or-n-p (format "delete file %s? " f)))
      (delete-file (fb-indicated-file))
      (let ((x buffer-read-only)) 
	(setq buffer-read-only nil)
	(delete-region
	 (progn (beginning-of-line) (point)) 
	 (progn (forward-line 1) (point)))
	(not-modified)
	(setq buffer-read-only x)
	)
      )
    (message "")
    )
  )

(defun fb-dired-file-other-window ()
  (interactive)
  (dired-other-window (fb-indicated-file))
  )

(defun fb-find-file ()
  (interactive)
  (find-file (fb-indicated-file))
  )

(defun fb-find-file-other-window ()
  (interactive)
  (find-file-other-window (fb-indicated-file))
  )

(defun fb-exec-file (&optional arg)
  (interactive "P")
  (aexec (fb-indicated-file) arg)
  )

(defun fb-w3-file ()
  (interactive)
  (let ((f (fb-indicated-file)))
    (w3-fetch (format "file://%s" 
		      (if (string-match "[a-z]:" f)
			  (substring f (match-end 0)) f)))
    (w3-parse-partial (progn 
			(set-buffer " *URL*")
			(buffer-string))
		      (zap-buffer (concat "w3 " f)))
    )
  )

(defun fb/ () (interactive)
  "produce recursive dired like listing on slash.
see variable *fb-db* "
  (let ((b (find-file-read-only *fb-db*)))
    (pop-to-buffer b)
    (cd-absolute (expand-file-name "/"))
    (fb-mode)

    )
  )

(defun fb (&optional buf)
  "view file listing from current directory"
  (interactive)
  (let ((b (or buf
	       (get-buffer-create
		(generate-new-buffer-name
		 (expand-file-name (pwd)))))))

    (shell-command "find . -print" b)
    (switch-to-buffer b)
    (beginning-of-buffer)
    (fb-mode))
  )

(defun fb-search-forward (pat) 
  (interactive 
   (list (read-string (format "search for (%s): " (fb-indicated-file)))))

  (fb-search
   (if (> (length pat) 0) pat
     (fb-indicated-file))))

(defun fb-search-backward (pat) 
  (interactive 
   (list (read-string (format "search for (%s): " (fb-indicated-file)))))
  (fb-search
   (setq fb-last-match nil
	 fb-last-pat
	 (if (> (length pat) 0) pat
	   (fb-indicated-file))) t))


(defun fb-file-info () (interactive)
  "
 0. t for directory, string (name linked to) for symbolic link, or nil.
 1. Number of links to file.
 2. File uid.
 3. File gid.
 4. Last access time, as a list of two integers.
  First integer has high-order 16 bits of time, second has low 16 bits.
 5. Last modification time, likewise.
 6. Last status change time, likewise.
 7. Size in bytes.
  This is a floating point number if the size is too large for an integer.
 8. File modes, as a string of ten letters or dashes as in ls -l.
 9. t iff file's gid would change if file were deleted and recreated.
10. inode number.  If inode number is larger than the Emacs integer,
  this is a cons cell containing two integers: first the high part,
  then the low 16 bits.
11. Device number.
"
  (let* ((fn (fb-indicated-file))
	 (a (file-attributes fn)))
  ; -rw-r--r--   1 544      everyone     2655 Mar 28  1998 woody
    (if a
	(message "%s %-4d %-4d %s %d %s %s"

	    (elt a 8)
	    (elt a 3)
	    (elt a 2)
	    "everyone"
	    (elt a 7)
	    (format-time-string "%b %d %Y" (elt a 5))
	    (file-name-nondirectory fn)
	    )
      (message "file not found"))
    )
  )

(defun fb-mode (&rest args)
  "mode for managing file index.
like view mode, with the following exceptions:
f		fb-find-file
RET		fb-exec-file
/		fb-search-forward
?		fb-search-backward
M-/	fb-match-file-forward
M-?	fb-match-file-backward
w		fb-w3-file
"
  (interactive)
  (use-local-map
   (or fb-mode-map (prog1
		       (setq fb-mode-map (copy-keymap view-mode-map))

		     (define-key fb-mode-map "g" 
		       '(lambda () (interactive)
			  (let ((default-directory default-directory))
			    (save-restriction
			      (widen)
			      (toggle-read-only -1)
			      (delete-region (point-min) (point-max)))
			    (fb (current-buffer))
			    )))
 
		     (define-key fb-mode-map "q" 
		       '(lambda () (interactive)
			  (kill-buffer (current-buffer))))

		     (define-key fb-mode-map "\C-m" 'fb-exec-file)
		     (define-key fb-mode-map "|" '(lambda (s) (interactive "sSearch for: ") (shell-command-on-region (point-min) (point-max) (concat "xargs egrep " s) (get-buffer-create (format "*egrep %s*" s)))))

		     (define-key fb-mode-map "w" 'fb-w3-file)

		     (define-key fb-mode-map "o" 'fb-find-file-other-window)
		     (define-key fb-mode-map "f" 'fb-find-file)

		     (define-key  fb-mode-map "D" 'fb-dired-file-other-window)
		     (define-key fb-mode-map "d" 'fb-dired-file) 

		     (define-key  fb-mode-map "x" 'fb-delete-file)

		     (define-key fb-mode-map [prior] 'fb-previous)
		     (define-key fb-mode-map [next] 'fb-next)

		     (define-key fb-mode-map [up] 'fb-up)

		     (define-key fb-mode-map "/" 'fb-search-forward)
		     (define-key fb-mode-map "?" 'fb-search-backward)

		     (define-key fb-mode-map "/" 'fb-match-file-forward)
		     (define-key fb-mode-map "?" 'fb-match-file-backward)

		     (define-key  fb-mode-map "p" 
		       '(lambda () 
			  (interactive)
			  (condition-case x
			      (cd (previous-qsave-search (current-buffer)))
			    (error nil))
			  )
		       )

		     (define-key  fb-mode-map "n" 
		       '(lambda () 
			  (interactive)
			  (condition-case x
			      (cd (next-qsave-search (current-buffer)))
			    (error nil))
			  )
		       )

		     (define-key fb-mode-map "i" 'fb-file-info)

		     (define-key fb-mode-map "\C-d" (lambda () (interactive) 
						      (let ((f (fb-indicated-file)))
							(if (file-exists-p f)
							    (delete-file f)
							  (message (format "%s f does not exist" f)))
							)
						      )
		       )
		     )
       )
   )

  (set-syntax-table 
   (or fb-mode-syntax-table
       (prog1
	   (setq fb-mode-syntax-table (make-syntax-table))
	 (loop for x across "#:+./-_~!"
	       do
	       (modify-syntax-entry x "w" fb-mode-syntax-table)
	       )
	 (if (eq window-system 'w32)
	     (loop for x across " \\"
		   do
		   (modify-syntax-entry x "w" fb-mode-syntax-table)
		   )
	   )
	 )
       )
   )

  (toggle-read-only 1)
  (set-buffer-modified-p nil)

  (setq mode-name "Fb")
  (and args
       (setq mode-name (concat mode-name "(" (apply 'format args) ")")))

  (setq major-mode 'fb-mode)
  (setq mode-line-process nil)
  (run-hooks 'fb-mode-hook)
  )


(defun fb-up () (interactive)
  " goto beginning of this directory"
  (let ((f (concat "^" (substring (file-name-directory (fb-indicated-file)) 0 -1) "$")))
    (while 
	(re-search-backward f nil t)
      )
    )
  )


(defun fb-previous () (interactive)
  " goto beginning of this directory"
  (if (bobp) nil
    (previous-line 1)
    (let ((f (concat "^" (substring (file-name-directory (fb-indicated-file)) 0 -1) "$")))
      (while 
	  (re-search-backward f nil t)
	)
      )
    )
  )

(defun fb-next () (interactive)
  " goto beginning of this directory"
  (let ((f (concat "^" (substring (file-name-directory (fb-indicated-file)) 0 -1))))
    (while 
	(re-search-forward f nil t)
      )
    (and (not (eobp))
	 (forward-line 1)
	 (beginning-of-line))
    )
  )



(defun ff-hack-pat (pat)
  " modify a regular expression with wildcards to match minimally. 
e.g. convert \"foo*bar\" to \"foo[^b]*bar\"
all other patterns (e.g. \"foo*\") remain unchanged.
"
  (let* ((sp 0)
	 (oldstr pat)
	 (newstr ""))
    (loop 
     while
     (string-match "*." oldstr)
     do
     (setq newstr
	   (concat newstr (substring oldstr 0 (match-beginning 0))
		   "[^" 
		   (substring oldstr (1+ (match-beginning 0)) (+ (match-beginning 0) 2))
		   "]*")
	   oldstr (substring oldstr (1+ (match-beginning 0))))
     finally return (concat newstr oldstr)
     )
    )
  )

(defun ff1 (db pat &optional b top)
  (let ((pat (ff-hack-pat pat))
	(b (or b (zap-buffer *fastfind-buffer*)))
	(top (or top "/"))
	)
    (setq *find-file-query*
	  (setq mode-line-buffer-identification 
		pat))

    (call-process "egrep" nil
		  b
		  nil
		  "-i" pat (expand-file-name
			    db))

    (set-buffer b)
    (beginning-of-buffer)
    (cd top)
    (fb-mode)

    (run-hooks 'after-find-file-hook)
    b)
  )

(defun ff (args)
  "fast find working dirs -- search for file matching pat in *fb-db*
with prefix arg, prompt for *fb-db* to use"

  (interactive "P")
  (let* ((top "/")
	 (b (zap-buffer *fastfind-buffer*))
  ;	 (*fb-db* *fb-db*) 
	 (pat 
	  (progn
	    (cond
	     ((and (listp args) (numberp (car args)))
	      ;; given prefix arg, read *fb-db*
	      (setq *fb-db* (read-file-name "db: " "" nil nil *fb-db*)
		    ))
	     ((stringp args) args)
	     ((interactive-p) (read-string "pat: "))))))
	    (if (= (length *fb-db*) 0)
		(progn
		  (setq *fb-db* *default-fb-db*)
		  (setq top "/"))
	      (progn 
		(if (file-directory-p *fb-db*)
		    (setq *fb-db* (concat *fb-db* "/f")))
		(setq top (file-name-directory *fb-db*)))
	      )

    (ff1 *fb-db* pat b top)

    (if (interactive-p) 
	(pop-to-buffer b)
      (split (buffer-string) "
")
      )
    )
  )

(defun fff (pat)
  (interactive "sPat: ")
  (let ((b (zap-buffer "*ff*")))
; xxx broken
    (shell-command (format "find . -name \"%s\"" pat) b nil)
    (pop-to-buffer b)
    (beginning-of-buffer)
    (run-hooks 'after-find-file-hook)
    (fb-mode)
    )
  )
; (fff "Config.ini")

(defun fh (pat)
  "fast find working drive -- search for file matching pat in homedirs"
  (interactive "spat: ")
;  (pop-to-buffer (ff1  *fb-db* (concat "^/[abcdpx]/*" pat)))
  (pop-to-buffer (ff1 *fb-h-db* pat))
  )


(defun fh2 ()
  "fast find working drive -- search for file matching pat in *fb-h-db*"
  (interactive)
  (let ((*fb-db* *fb-h-db* )) (call-interactively 'ff2)
  )
)

(defun multi-join (l)
  " multi-way join on set of files l.  
returns a filename containing results"
  (save-excursion
    (let ((fn1 (pop l))
	  (b (zap-buffer " *multi-join*")))
      (loop 
       for f in l
       do
       (call-process "join" nil
		     b
		     nil
		     f fn1)
       (set-buffer b)
       (write-file fn1)
       (erase-buffer)
       (set-buffer-modified-p nil)
       )
      (kill-buffer b)
      fn1)
    )
  )

(defun ff2-helper (n pat)
  (let ((b (zap-buffer " _ff"))
	(fn (mktemp (format "_ff%d" n))))

    (call-process "egrep" nil
		  b
		  nil
		  "-i" pat *fb-db*)
    (set-buffer b)
    (sort-lines nil (point-min) (point-max))
    (write-file fn)
    (kill-buffer b)
    fn)
  )

(defun ff2 (&rest pats)
  "fast find current drive -- search for file matching pat in *fb-db*"
  (interactive (butlast
		(loop 
		 with pat = nil
		 until (and (stringp pat) (< (length pat) 1))
		 collect (setq pat (read-string "pat: ")))
		1))

  (let* ((l (loop for pat in pats
		  with i = 0
		  collect (prog1 
			      (ff2-helper i pat)
			    (setq i (1+ i)))))
	 (fn (multi-join l))
	 (b (zap-buffer *fastfind-buffer*)))

    (set-buffer b)
    (insert-file fn)
    (setq *find-file-query*
	  (setq mode-line-buffer-identification 
		(mapconcat '(lambda (x) x) pats "&")))
    (goto-char (point-min))
    (cd "/")
    (fb-mode)

    (run-hooks 'after-find-file-hook)

    (if (interactive-p) 
	(pop-to-buffer b)
      (split (buffer-string) "
")
      )

    (loop
     for x in l
     do (delete-file x))
    b)
  )

(defun fall () 
  (interactive)
  (let ((*fb-db* *fb-full-db*)) (call-interactively 'ff))
  )

(defun !ff (pat cmd) 
  "like fff, but runs cmd on each file and collects the result"
  (interactive "spat: \nscmd: ")

  (let ((b (zap-buffer *fastfind-buffer*))
	(p (catlist cmd ? ))
	)

    (loop 
     for d in '("c" "e") ; XXX gen from registry
     do

     (let* ((s (eval-process "egrep" "-i" pat (format "%s:%s" d *fb-db*)))
	    (l (loop for f in (catlist s 10)
		     collect
		     (apply 'eval-process
			    (car p)
			    (nconc (cdr p) (list (format "\"%s\"" f)))))))

       (set-buffer b)
       (loop for f in l do (insert f))
       )
     )

    (pop-to-buffer b)
    (beginning-of-buffer)
    (cd "/")
    (fb-mode)
    )
  )

(setq picpat "\"gif$\\|jpg$\\|bmp$\\|png$\\|tif$\"")

(defun fpic ()
  "fast find all drives -- search for file matching pat in *:`cat *fb-db*`"
  (interactive)

  (let ((b (zap-buffer "*fpic*")))
    (loop 
     for d in '("c" "e")
     do

     (let ((s (eval-process "egrep" "-i" picpat (format "%s:%s" d *fb-db*))))
       (set-buffer b)
       (insert s)
       )
     )

    (pop-to-buffer b)
    (beginning-of-buffer)
    (cd "/")
    (fb-mode)
    )
  )

(defun fl (pat)
  "fast find using locate"

  (interactive "spat: ")

  (let ((b (zap-buffer *fastfind-buffer*))
	(top "/"))

    (call-process "locate" nil
		  b
		  nil
		  pat)

    (set-buffer b)
    (beginning-of-buffer)
    (cd top)

    (if (interactive-p) 
	(progn (pop-to-buffer b)
	       (fb-mode))
      (split (buffer-string) "
")
      )
    )
  )

(provide 'fb)
