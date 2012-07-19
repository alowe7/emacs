(put 'post-xz 'rcsid 
 "$Id$")

; (eval-when-compile (require 'xz))

(require 'advice)
(require 'long-comment)
(require 'qsave)
(require 'cat-seq)

(defvar *xz-dirs* (mapcar 'list (catpath "XZDIRS"))
  "list of directories containing xz databases.
used for autocompletion on interactive call to start-xz.
may be initialized from environment variable XZDIRS
"	)

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
  (with-current-buffer (xz-buffer)
    (car (read-from-string (buffer-string)))))

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
			   (define-key xz-mode-map "i" 'xz-which-hit)
			   (define-key xz-mode-map "[" '(lambda () (interactive) (xz-squish (max 0 (1- *xz-squish*)) t)))
			   (define-key xz-mode-map "]" '(lambda () (interactive) (xz-squish (1+ *xz-squish*) t)))
			   (define-key xz-mode-map "." '(lambda () (interactive) (message "squish level is: %d" *xz-squish*)))
			   (xz-squish 4)
			   (setq *xz-show-status* nil)
			   )
	  )

; (global-set-key "\M-n" 'xz-next-hit)
; (global-set-key "\M-p" 'xz-previous-hit)

(setq *xz-lastdb* "~/emacs/.xz.dat")

(add-hook 'stop-xz-process-hook '(lambda ()
				   (put (intern (buffer-name (xz-hit-buffer))) 'qsave nil)))


