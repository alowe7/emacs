(put 'xz-helpers 'rcsid 
 "$Id: xz-helpers.el,v 1.8 2001-07-11 09:57:01 cvs Exp $")
(require 'advice)
(require 'long-comment)

(defvar *xz-dirs* (mapcar 'list (catpath "XZDIRS"))
  "list of directories containing xz databases.
used for autocompletion on interactive call to start-xz.
may be initialized from environment variable XZDIRS
"	)

(defun xz-try-completion (s l)
  (let ((c (try-completion s l)))
    (cond ((or (null c) (eq c t)) s)
	  (t c))
    )
  )

		
(defadvice minibuffer-complete-word (around interactive-xz-completion first disable)
  ""
  (let ((s (buffer-string)))
    (erase-buffer)
    (insert (xz-try-completion s *xz-dirs*)))
  ad-do-it)

		
(defadvice completing-read (around interactive-xz-completion disable)

  (ad-enable-advice 
   'minibuffer-complete-word
   'around
   'interactive-xz-completion)

  (ad-activate 'minibuffer-complete-word)

  ad-do-it

  (ad-disable-advice
   'minibuffer-complete-word
   'around
   'interactive-xz-completion)

  (ad-activate 'minibuffer-complete-word)

  )

		
(defun xz-completing-read (prompt default)
  "helper to implement completing read from *xz-dirs*
 used as advice on start-xz
"
  (let (v)
    (ad-enable-advice 
     'minibuffer-complete-word
     'around
     'interactive-xz-completion)

    (ad-activate 'minibuffer-complete-word)

    (setq v 
	  (loop 
	   with s = (completing-read
		     (format "run %s on (%s): " *xz-command* default)
		     *xz-dirs*)
	   while (and (> (length (all-completions s *xz-dirs*)) 1)
		      (not (string= s (xz-try-completion s *xz-dirs*))))
	   do 
	   (with-output-to-temp-buffer "*completions*"
	     (display-completion-list (all-completions s *xz-dirs*)))
	   (display-buffer "*completions*")
  ; (sit-for 1)
	   (setq s (completing-read
		    (format "run %s on (%s): " *xz-command* s)
		    *xz-dirs* nil nil s))
	   finally return (or (xz-try-completion s *xz-dirs*) s)
	   ))

    (ad-disable-advice
     'minibuffer-complete-word
     'around
     'interactive-xz-completion)

    (ad-activate 'minibuffer-complete-word)

    (string* ($ (maybe-complete-world v)) default)
    )
  )

(/* XXX this doesn't work as planned...

    (defadvice start-xz (around interactive-world-completion activate)
      (interactive  (list (expand-file-name 
			   (xz-completing-read
			    (format "run %s on (%s): " *xz-command* (default-xz-file))
			    (default-xz-file)))))
      ad-do-it)
    )

;(ad-unadvise 'start-xz)

; alternative find line that doesn't visit the file
; should build getl functionality into xz.
(defun find-line (module line)
  "find line associated with hit"
  (save-excursion 
    (let ((f (expand-file-name module)))
      (if (file-exists-p f)
	  (let 
	      ((b (zap-buffer " *tmp*")))

	    (call-process "getl" f b nil (format "%s" (max line 1)))

	    (set-buffer b)
	    (if (= (point-max) (point-min))
		"<no such line>"
	      (buffer-substring (point-min) (1- (point-max))))
	    )
	""))
    )
  )


(defun any-xz (dir query)
  "iterate over all xz processes until find one matching dir.
if found, pop that to top of stack"
  (interactive "sdir: \nsquery: ")
  (let ((p (loop 
	    for i from 0 to (1- (length *xz-process-stack*))
	    thereis 
	    (and (string-match dir 
			       (xz-cell-db (nth i *xz-process-stack*)))
		 (nth i *xz-process-stack*))
	    )))
    (if p
	(progn
	  (push p *xz-process-stack*)
	  (xz-query-format query)
	  (pop *xz-process-stack*))
      )
    )
  )

(define-key xz-map (vector 67108914) 'any-xz)   ;?C-2

(defun xz-get-results ()
  "get results of last xz query"
  (save-excursion
    (set-buffer (xz-buffer))
    (car (read-from-string (buffer-string)))))


(defun xz-shell-get-results (beg end)
  "get results from an xz query in the interactive shell "
  (let* ((s (buffer-substring beg end)
	    ))
    (loop for l in (split s "
") 
	  collect (split l ","))    
    )
  )

(defun xz-mean (a b)
  (if (= b 0) 0 (/ a b))
  )

; this space intentionally left blank
(defvar *xz-shell-prompt-regexp* "#")

(defun xz-sum-fields ()
  "sum the numeric fields of an appropriate length or statement xz query.
if in shell mode, assume an interactive xz process
"

  (interactive)
  (let* ((p (and
	     (eq major-mode 'shell-mode)
	     (save-excursion
	       (goto-char (1- (marker-position (process-mark (buffer-process)))))
	       (looking-at *xz-shell-prompt-regexp*)
	       (point))))
	 (l (if p (xz-shell-get-results
		   (marker-position comint-last-input-end)
		   p
		   )
	      (xz-get-results)))
	 (v (loop for h in l
		  sum  (number* (caddr h)) into s
		  count 1 into n
		  finally return (cons s n))))
    (message "sum is %d (n=%d, m=%s)" (car v) (cdr v) (xz-mean (car v) (cdr v)))
    (setq $_ v))
  )


(define-key
  xz-map 
  (vector 67108925) ; \C-=
  'xz-sum-fields) 
