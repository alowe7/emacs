(put 'fb 'rcsid 
 "$Id: fb.el,v 1.10 2000-10-17 20:53:11 cvs Exp $")
(require 'view)
(require 'isearch)
(require 'cat-utils)
(require 'qsave)


(defvar fb-mode-map nil "")
(defvar fb-mode-syntax-table nil "")
(defvar fb-mode-hook nil)
(defvar fb-last-pat nil)
(defvar fb-last-match nil)

(defvar *fastfind-buffer* "fastfind")

(defconst *fb-db* 
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
  (qsave-search (current-buffer) *find-file-query*)
  )
(defvar after-find-person-hook nil)
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


(defun fb-dired-file ()
  (interactive)
  (dired (indicated-word))
  )

(defun fb-delete-file ()
  (interactive)
  (let ((f (indicated-word)))
    (unless (not (y-or-n-p (format "delete file %s? " f)))
      (delete-file (indicated-word))
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
  (dired-other-window (indicated-word))
  )

(defun fb-find-file ()
  (interactive)
  (find-file (indicated-word))
  )

(defun fb-find-file-other-window ()
  (interactive)
  (find-file-other-window (indicated-word))
  )

(defun fb-exec-file (&optional arg)
  (interactive "P")
  (aexec (indicated-word) arg)
  )

(defun fb-w3-file ()
  (interactive)
  (let ((f (indicated-word)))
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

(global-set-key "" 'fb)

(defun fb-search-forward (pat) 
  (interactive 
   (list (read-string (format "search for (%s): " (indicated-word)))))

  (fb-search
   (if (> (length pat) 0) pat
     (indicated-word))))

(defun fb-search-backward (pat) 
  (interactive 
   (list (read-string (format "search for (%s): " (indicated-word)))))
  (fb-search
   (setq fb-last-match nil
	 fb-last-pat
	 (if (> (length pat) 0) pat
	   (indicated-word))) t))

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
			  (previous-qsave-search (current-buffer))))

		     (define-key  fb-mode-map "n" 
		       '(lambda ()
			  (interactive)
			  (next-qsave-search (current-buffer))))

		     )
       )
   )

  (set-syntax-table 
   (or fb-mode-syntax-table
       (prog1
	   (setq fb-mode-syntax-table (make-syntax-table))
	 (if (eq window-system w32) 
	     (loop for x across "#:+ ./-_~!\\"
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
  (let ((f (concat "^" (substring (file-name-directory (indicated-word)) 0 -1) "$")))
    (while 
	(re-search-backward f nil t)
      )
    )
  )


(defun fb-previous () (interactive)
  " goto beginning of this directory"
  (if (bobp) nil
    (previous-line 1)
    (let ((f (concat "^" (substring (file-name-directory (indicated-word)) 0 -1) "$")))
      (while 
	  (re-search-backward f nil t)
	)
      )
    )
  )

(defun fb-next () (interactive)
  " goto beginning of this directory"
  (let ((f (concat "^" (substring (file-name-directory (indicated-word)) 0 -1))))
    (while 
	(re-search-forward f nil t)
      )
    (and (not (eobp))
	 (forward-line 1)
	 (beginning-of-line))
    )
  )

(defun fh ()
  "fast find working drive -- search for file matching pat in *fb-h-db*"
  (interactive)
  (let ((*fb-db* *fb-h-db* )) (call-interactively 'ff))
  )


(defun ff (args)
  "fast find working dirs -- search for file matching pat in *fb-db*"
  (interactive "sargs: ")
  (let ((b (zap-buffer *fastfind-buffer*))
	(pat args))

    (setq *find-file-query*
	  (setq mode-line-buffer-identification 
		pat))

    (call-process "egrep" nil
		  b
		  nil
		  "-i" pat *fb-db*)

    (set-buffer b)
    (beginning-of-buffer)
    (cd "/")
    (fb-mode)

    (run-hooks 'after-find-file-hook)

    (if (interactive-p) 
	  (pop-to-buffer b)
      (split (buffer-string) "
")
      )
    )
  )

(defun fh2 ()
  "fast find working drive -- search for file matching pat in *fb-h-db*"
  (interactive)
  (let ((*fb-db* *fb-h-db* )) (call-interactively 'ff2)
  )
)

(defun ff2 (pat1 pat2)
  "fast find current drive -- search for file matching pat in *fb-db*"
  (interactive "spat1: \nspat2: ")
  (let ((b (zap-buffer *fastfind-buffer*))
	(b1 (zap-buffer " _ff1"))
	(fn1 (mktemp "_ff1"))
	(b2 (zap-buffer " _ff2"))
	(fn2 (mktemp "_ff2")))

    (setq *find-file-query*
	  (setq mode-line-buffer-identification 
		(concat pat1 "&" pat2)))

    (call-process "egrep" nil
		  b1
		  nil
		  "-i" pat1 *fb-db*)
    (set-buffer b1)
    (sort-lines nil (point-min) (point-max))
    (write-file fn1)

    (call-process "egrep" nil
		  b2
		  nil
		  "-i" pat2 *fb-db*)
    (sort-lines nil (point-min) (point-max))
    (set-buffer b2)
    (write-file fn2)

    (call-process "join" nil
		  b
		  nil
		  fn1 fn2)

    (set-buffer b)
    (beginning-of-buffer)
    (cd "/")
    (fb-mode)

    (run-hooks 'after-find-file-hook)

    (if (interactive-p) 
	  (pop-to-buffer b)
      (split (buffer-string) "
")
      )
    )
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

(setq picpat  "\"gif$\\|jpg$\"")

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

(provide 'fb)
