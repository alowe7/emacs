(put 'fb 'rcsid
 "$Id: fb.el,v 1.6 2005-12-17 05:01:10 tombstone Exp $")

; this module overrides some functions defined in fb.el
; by default on windows platforms, locate via grep 

(chain-parent-file t)

; ignore case in file equivalences
(setq *file-name-member* 'member-ignore-case)

(defun ff1 (db pat &optional b top)
  (let ((pat (funcall ff-hack-pat pat))
	(b (or b (zap-buffer *fastfind-buffer*)))
	(top (or top "/"))
	)
    (setq *find-file-query*
	  (setq mode-line-buffer-identification 
		pat))

    (call-process "grep" nil
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

(defun ff0 (args)
  "fast find working dirs -- search for file matching pat in *fb-db*
with prefix arg, prompt for `*fb-db*' to use
if none given, uses `*default-fb-db*' 
"

  (interactive "P")

  (let* ((top default-directory)
  ; 	with prefix arg, make sure buffer is in a rational place
	 (pat 
	  (cond
	   ((and (listp args) (numberp (car args)))
	    ;; given prefix arg, read *fb-db* and pat
	    (progn 
	      (setq *fb-db* (read-file-name "db: " "" nil nil *fb-db*))
	      (read-indicated-string "pat")
	      )
	    )
	   ((stringp args) args) 
	   (t (read-indicated-string "pat")))
	  )
	 (b (zap-buffer *fastfind-buffer* (and args '(cd top))))
  ;	 (*fb-db* *fb-db*) 
	 db
	 )

    (if (= (length *fb-db*) 0)
	(progn
	  (setq *fb-db* *default-fb-db*)
	  (setq top "/")
	  )

      (progn 
	(if (file-directory-p *fb-db*)
	    (setq *fb-db* (concat *fb-db* "/f")))
	(setq 
	 top (file-name-directory *fb-db*)
	 )
	)
      )

    (ff1 *fb-db* pat b top)

    (if (interactive-p) 
	(pop-to-buffer b)
      (split (buffer-string) "
")
      )
    )
  )


(defun ff (pat)
  "fast find files -- search for file matching PAT in `*fb-db*'"

  (interactive "sfind files: ")
  (let* ((top default-directory)
	 (default-directory "/")
	 (b (zap-buffer *fastfind-buffer*))
	 f)

    (if (= (length *fb-db*) 0)
	(progn
	  (setq *fb-db* *default-fb-db*)
	  (setq top "/")
	  )

      (progn 
	(if (file-directory-p *fb-db*)
	    (setq *fb-db* (concat *fb-db* "/f")))
	(setq 
	 top (file-name-directory *fb-db*)
	 )
	)
      )

    (ff1 *fb-db* pat b top)

  ; try to avoid splitting (buffer-string) 

    (cond ((and *fb-auto-go* 
		(interactive-p) 
		(= (count-lines (point-min) (point-max)) 1)
		(not (probably-binary-file (setq f (car (split (buffer-string) "
"))))))
  ; pop to singleton if appropriate
	   (find-file f))
  ; else pop to listing if interactive
	  ((interactive-p)
	   (pop-to-buffer b))
  ; else just return the list
	  (t (split (buffer-string) "
")
	     ))
    )
  )


(defun ff2-helper (n pat)
  (let ((b (zap-buffer " _ff"))
	(fn (mktemp (format "_ff%d" n))))

    (call-process "grep" nil
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


(defun !ff (pat cmd) 
  "like fff, but runs cmd on each file and collects the result"
  (interactive "spat: \nscmd: ")

  (let ((b (zap-buffer *fastfind-buffer*))
	(p (catlist cmd ? ))
	)

    (loop 
     for d in '("c" "e") ; XXX gen from registry
     do

     (let* ((s (eval-process "grep" "-i" pat (format "%s:%s" d *fb-db*)))
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

(defun fbf (pat)
  "fast find files containing PAT"

  (interactive "spat: ")

  (let* ((top default-directory)
	 (b (zap-buffer "*ff1*" '(lambda () (cd top))))
	 (grep-args (nconc '("-H") 
			    (and *fb-case-fold* '("-i"))
			    (and  *fb-show-lines* '("-n"))))
	 )

    (apply 'call-process 
	   (nconc (list "find" nil b nil)
		  (list "." "-type" "f" "-exec" "grep")
		  grep-args
		  (list pat "{}" ";")))
    
    (pop-to-buffer b)
    (beginning-of-buffer)
    (fb-mode)
    )
  )
; (fbf "fbf")

; moved from parent
(require 'advice)

(defadvice locate (around 
		   hook-locate
		   first activate)
  ""

  (let ((pat (ad-get-arg 0)))
    (and (buffer-live-p (get-buffer locate-buffer-name))
	 (save-excursion (set-buffer locate-buffer-name) (setq buffer-read-only nil)))
    ad-do-it
    (setq *find-file-query*
	  (setq mode-line-buffer-identification (format "%-22s" pat)))
    (fb-mode)
    (run-hooks 'after-find-file-hook))
  )
; (if (ad-is-advised 'locate) (ad-unadvise 'locate))
