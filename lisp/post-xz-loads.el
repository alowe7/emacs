(put 'post-xz-loads 'rcsid 
 "$Id: post-xz-loads.el,v 1.13 2005-08-22 20:55:03 cvs Exp $")

(require 'advice)
(require 'long-comment)
(require 'xz-stacks)
(require 'qsave)

(defvar *xz-dirs* (mapcar 'list (catpath "XZDIRS"))
  "list of directories containing xz databases.
used for autocompletion on interactive call to start-xz.
may be initialized from environment variable XZDIRS
"	)

(defvar *xz-complete-dirs* nil)

(unless (not *xz-complete-dirs*)

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

  ;  (ad-unadvise 'minibuffer-complete-word)

		
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

  ;  (ad-unadvise 'completing-read)

		
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

  )

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


;; where should this go?

(defun xz-qsave-search () 
  ; save output of each xz search on a stack for retrieval

  (cond (*xz-vec*
	 (qsave-search (xz-hit-buffer)
		       *xz-query* (list (xz-process) *xz-result* *xz-vec*))

	 (let ((l (count-lines (point-min) (point-max))))
	   (if (and (> l 0) 
		    (or xz-always-go 
			(<= l xz-auto-go)))
	       (xz-goto-hits))))
	)
  )

(add-hook 'xz-after-search-hook 'xz-qsave-search)

(defun previous-xz-search () (interactive) 
  (let ((d (previous-qsave-search (xz-hit-buffer))))
    (if d 
	(setq *xz-result* (cadr d)
	      *xz-vec* (caddr d)))))

(defun next-xz-search () (interactive) 
  (let ((d (next-qsave-search (xz-hit-buffer))))
    (if d 
	(setq *xz-result* (cadr d)
	      *xz-vec* (caddr d)))))

(defun prune-xz-search (n) 
  (interactive "nprune history to depth: ")
  (setq buffer-read-only nil)
  (prune-search n (xz-hit-buffer))
  (setq buffer-read-only t))

(defun xz-goto-function-definition (string)
  (interactive (list (complete-indicated-word "goto function definition (%s): " obarray)))
  (xz-query-format (concat "./fd" (or (and (> (length string) 0) string)  (indicated-word)))))

(defun xz-goto-variable-declaration (string)
  (interactive (list (complete-indicated-word "goto variable declaration (%s): " obarray)))
  (xz-query-format (concat "./id" (or (and (> (length string) 0) string)  (indicated-word))))
  )

(define-key xz-map "f" 'xz-goto-function-definition)
(define-key xz-map "v" 'xz-goto-variable-declaration)

(define-key xz-map (vector 67108914) 'any-xz)   ; \C-2
(define-key xz-map (vector 67108925) 'xz-sum-fields)  ; \C-=

(define-key xz-map "" 'xz-next-hit)
(define-key xz-map "" 'xz-previous-hit)

(add-hook 'xz-load-hook '(lambda ()
			   (define-key xz-mode-map "d" 'prune-xz-search)
			   (define-key xz-mode-map "f" 'xz-goto-hits)
			   (define-key xz-mode-map "n" 'next-xz-search)
			   (define-key xz-mode-map "n" 'next-xz-search)
			   (define-key xz-mode-map "p" 'previous-xz-search)
			   )
	  )

; (global-set-key "\M-n" 'xz-next-hit)
; (global-set-key "\M-p" 'xz-previous-hit)


(add-hook 'stop-xz-process-hook '(lambda ()
				   (put (intern (buffer-name (xz-hit-buffer))) 'qsave nil)))
