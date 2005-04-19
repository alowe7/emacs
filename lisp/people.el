(put 'people 'rcsid 
 "$Id: people.el,v 1.18 2005-04-19 00:20:45 cvs Exp $")
(provide 'people)
;; manage people databases
(require 'compile)
(require 'qsave)

(defvar *people-database* "" "list of contact files")

(defun note (&optional arg) 
  "find person in database.  see `find-person'
with optional arg, add line to database.  see `find-person-1'"
  (interactive "P")
  (if arg (call-interactively 'find-person-1)
    (call-interactively 'find-person))
  )

(defvar compilation-process nil)

(defun egrep (args)
  "Run egrep, with user-specified args, and collect output in a buffer.
While grep runs asynchronously, you can use the \\[next-error] command
to find the text that grep hits refer to."
  (interactive "sRun grep (with args): ")
  (compile1 (concat "egrep -n " args " " grep-null-device)
	    "No more grep hits" "grep"))

(global-set-key "g" 'egrep)

(defvar *find-person-egrep-switches*  '("-w" "-h"  "-i"))

(defun find-person-2 (name &optional db)
  (interactive "swho? ")
  (let ((*find-person-egrep-switches*  '("-h"  "-i")))
    (find-person name db)
    ))

(defvar *contact-cache* nil "cache of contact files. computed on first use")
(defvar *filecache* "/var/spool/f" "nih file directory")

(defun contact-cachep (&optional force)
  "recompute `*contact-cache*' if:
	we don't have a cache, or
	we force it, or
	`*filecache*' is older than the last time we computed `*contact-cache*', or
	at least one file in `*contact-cache*' doesn't exist"

    (cond ((and *contact-cache*
		(not force)
		(>= 0 (compare-filetime
		       (filemodtime *filecache*)
		       (get '*contact-cache* 'computed)))
		(loop for x
		      in *contact-cache*
		      if (not (file-exists-p x))
		      return (*contact-cachep* t)
		      )
		)
	   )
	  (t 
	   (setq *contact-cache*
		 (nconc *people-database*
			(catlist (perl-command "contact-cache" *filecache*) ?
				 )
			))
	   (put '*contact-cache* 'computed (elt (file-attributes *filecache*) 5)))
	  )
    *contact-cache*
  )

(defvar people-mode-map	nil "keymap for hit buffer")

(defun people-mode ()
  "mode for browsing people see (find-person)
	uses people-mode-map
	runs people-mode-hook
"
  (interactive)
  (use-local-map people-mode-map)
  (setq major-mode 'people-mode)
  (setq mode-name "people")
  (run-hooks 'people-mode-hook)
  (set-buffer-modified-p nil)
  ;  (toggle-read-only)
  )

(defvar *find-person-vector* nil)
(make-variable-buffer-local '*find-person-vector*)
(defvar *find-person-query* nil)
(make-variable-buffer-local '*find-person-query*)

(defvar after-find-person-hook nil)
(defvar before-find-person-hook nil)

(add-hook 'after-find-person-hook 'find-person-save-search)


(defun find-person-save-search ()
  (qsave-search (current-buffer) *find-person-query* *find-person-vector*)
)

(defun make-person-vector (name b)
  (save-excursion
    (set-buffer b)
    (beginning-of-buffer)

    (setq *find-person-query* name)

    (setq *find-person-vector*
	  (apply 'vector
		 (loop 
		  while (re-search-forward ":[0-9]+:" nil t)
		  collect
		  (list
		   (buffer-substring 
		    (save-excursion (beginning-of-line) (point))
		    (match-beginning 0))
		   (read (buffer-substring 
			  (1+ (match-beginning 0))
			  (1- (match-end 0))))
		   (buffer-substring 
		    (match-end 0)
		    (save-excursion (end-of-line) (point)))
		   )
		  )))
    )
  (erase-buffer)
  (cd "/")
  (loop 
   for x across  *find-person-vector*
   do
   (insert (caddr x))
   (insert "\n")
   )
  )

(if people-mode-map ()
  (setq people-mode-map (make-sparse-keymap))
  (define-key people-mode-map "\C-m" 'people-goto-hit)
  ; (define-key  people-mode-map "o" '(lambda () (interactive) (people-goto-hit t)))
  (define-key  people-mode-map "?" 'people-describe-hit-briefly)
  (define-key  people-mode-map "s" 'people-show-hit)
  (define-key  people-mode-map "e" '(lambda () (interactive)
				      (let* ((l (count-lines (point-min) (point)))
					     (v (aref *find-person-vector* (if (bolp) l (1- l)))))
					(unless (not v)
					  (find-file (car v))
					  (goto-line (cadr v))))))
  (define-key  people-mode-map "p" 'roll-qsave)
  (define-key  people-mode-map "n" ''roll-qsave-1)

  (define-key  people-mode-map ""
    '(lambda (n) (interactive "nprune to depth: ")
       (prune-search (get-buffer "*people*") n)))
)

(defun people-goto-hit (&optional other-window) 
  "pop to a hit.  with arg, pops to hit in other window" 
  (interactive "P")
  (let* ((l (count-lines (point-min) (point)))
	 (v (aref *find-person-vector* (if (bolp) l (1- l)))))

    (unless (not v)
      (if other-window
	(find-file-other-window (expand-file-name (car v)))
	 (find-file (expand-file-name (car v))))
      (goto-line (cadr v))
      )
    )
  )

(defun people-show-hit (arg) 
  "show file and line number for a hit."
  (interactive "P")
  (let* ((l (count-lines (point-min) (point)))
	 (v (aref *find-person-vector* (if (bolp) l (1- l))))
	 (n (car (split (caddr v) ","))))

    (start-process (format "show-%s" n) nil "run" "show" (if arg (read-string "name: ") n))

    )
  )

(defun people-describe-hit-briefly () 
  "show file and line number for a hit."
  (interactive)
  (let* ((l (count-lines (point-min) (point)))
	 (v (aref *find-person-vector* (if (bolp) l (1- l)))))

    (unless (not v)
      (message (format "%s:%d" (car v) (cadr v))))
    )
  )

(defvar *minibuffer-display-unique-hit* nil "if set, use minibuffer to display a single hit.  otherwise, always pop up a buffer")

; todo: concoct list, read key for more.
(defun find-person (name &optional db)
  " search `*people-database*' for regexp NAME
    if optional DB is specified, search it.

	runs find-person-hook after search
"
  (interactive "swho? ")
  (let* ((b (prog1 (zap-buffer "*people*") (people-mode)))
	 (tmpfilename (make-temp-file "note"))
	 (db (or db 
		 *people-database*))
	 (gcl (split grep-command))
	 (e (progn (apply 'call-process 
			  (nconc (list (car gcl) nil (list b tmpfilename) nil "-H") (cdr gcl) (list name) db))))
	 n)

    (cond ((> (nth 7 (file-attributes tmpfilename)) 0)
	   (message (read-file tmpfilename))
	   (delete-file tmpfilename))
	  (t
	   (make-person-vector name b)
	   (run-hooks 'after-find-person-hook)

	   (set-buffer b)

	   ;; if result is one-line & buffer isn't already showing in a window, 
	   ;; then message it.  otherwise, just display in buffer
	   (setq n (count-lines (point-min) (point-max)))
	   (unless (cond 
		    ((zerop n) ; if not found try harder
		     (find-person-1 name db))
	   
		    ((and (not (get-buffer-window b))
			  (= 1 n)
			  *minibuffer-display-unique-hit*)
		     (progn
	      
		       (message "%s" (clean-string (buffer-string)))
		       (kill-buffer b)
		       t)))
	     (pop-to-buffer b)
	     (beginning-of-buffer)
	     (set-buffer-modified-p nil)
	     (setq buffer-read-only t)
	     )
	   )
	  )
    )
  )

(defvar *note-program* "note" "external program used to find notes")

(defun find-person-1 (name &optional db)
  " call external process `*note-program*' to find people and notes
	runs `after-find-person-hook' after search
"
  (interactive "swho? ")
  (let* ((b (prog1 (zap-buffer "*people*") (people-mode)))
	 (tmpfilename (make-temp-file "note"))
	 (e (apply 'call-process
		   (nconc (list "grep" nil (list b tmpfilename) nil "-i" "-n" name) db)))
	 n)

    (cond ((> (nth 7 (file-attributes tmpfilename)) 0)
	   (message (read-file tmpfilename))
	   (delete-file tmpfilename))
	  (t
	   (make-person-vector name b)
	   (run-hooks 'after-find-person-hook)

	   ;; if result is one-line & buffer isn't already showing in a window, 
	   ;; then message it.  otherwise, just display in buffer
	   (setq n (count-lines (point-min) (point-max)))
	   (unless (cond 
		    ;;	 ((and (null db) (zerop n)) (find-person name *tkg-people*))
		    ((zerop n) ; if not found locally, and w3 is loaded, try a dbquery
		     (if (and (boundp 'w3-version) (functionp 'w3-find-person)
			      (y-or-n-p (format "lookup %s on the web?" name)))
			 (w3-find-person name)
		       (message "%s not found" name)))
		    ((and (not (get-buffer-window b)) (= 1 n))
		     (progn
	      
		       (message "%s" (clean-string (buffer-string)))
		       (kill-buffer b)
		       t)))
	     (pop-to-buffer b)
	     (beginning-of-buffer)
	     (set-buffer-modified-p nil)
	     (setq buffer-read-only t)
	     )
	   )
	  )
    )
  )


(defun first-person () (interactive)
  (beginning-of-buffer)
  (next-person)
  )

(defun next-person () (interactive)
  (re-search-forward compilation-error-regexp)
  (message
   (substring (buffer-string)
	      (match-beginning 2)
	      (1+ (match-end 2))
	      )
   )
  )

(defun grab-person (name &optional db)
  "look up NAME in optional DB.
default is *people-database*"
  (interactive "sName: ")
  (let ((s  (eval-process  "grep" "-i" name
			   (or db *people-database*))))
    (if (interactive-p) (message s) s)
    )
  )


(defun add-person (line)
  (interactive "sadd line: ")
  (let* ((f (if (listp *people-database*) (car *people-database*) *people-database*))
	 (b (get-file-buffer f))
	 (w (and b (get-buffer-window b))))
    (call-process "binecho" nil (if w nil 0)  nil f line)
  ; if window showing buffer, wait
    (if w (edit-people-database))
    ))

(defun edit-people-database ()
  (let* ((f (if (listp *people-database*) (car *people-database*) *people-database*))
	 (b (or (get-file-buffer f)
		(find-file-noselect f t)))
	 (w (get-buffer-window b)))
    (or w (pop-to-buffer b))
    (select-window (get-buffer-window b))
    (set-buffer b)
    (or (verify-visited-file-modtime b) 
	(revert-buffer t t)) ; make sure it matches the version on disk
    (end-of-buffer)
    ))

(defun people (&optional arg) 
  "add entries to people database.  
with prefix arg, prompt for a line to add"
  (interactive "P")
  (if arg (call-interactively 'add-person)
    (edit-people-database))
  )

(run-hooks 'people-load-hook)
