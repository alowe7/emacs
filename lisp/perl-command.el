(put 'perl-command 'rcsid
 "$Id: perl-command.el,v 1.6 2003-08-29 16:50:28 cvs Exp $")
; facilitate running perl commands
(require 'cl)
(require 'zap)
(require `backquote)

(defvar semicolon (read "?;"))
(defvar *perl-buffer-name* " *perl*")

(defun find-script (s &optional processor l)
  (interactive "sscript: ")
  "find SCRIPT using optional PROCESSOR along optional PATH
if PROCESSOR is specified, search is qualified to files matching 
it as a regexp in sh-bang construct in first line of script.
if LIST is specified, it is used instead of default PATH
"
  ;; let's not overlook the obvious

  (let (l (s* (expand-file-name (substitute-in-file-name s))))
    (if 
	(file-exists-p s*) s*
      (setq l (or l (getenv "PATH")))
      (loop for x in (mapcar 'expand-file-name (split l path-separator))
	    with cript = nil
	    when (and (file-exists-p (setq cript (concat x "/" s)))
		      (or (not processor)
			  (string-match processor (eval-process "head" "-1" cript))))
	    return cript)
      )
    )
  )


(defun get-buffer-create-1 (bn &optional dir)
  (zap-buffer bn `(lambda () (cd ,dir)))
  )

(defun* perl-command-1 (s &key show args)
  " run perl script S on ARGS
keyword args :show  :args
if show=eval reads results from string into retval
elsif show=split returns results as a split list from string into retval
else unless (null :show) pops to buffer
else returns result as a string
:args are passed along unevaluated to script unless
args is a list with car = 'eval
" 

  (save-excursion
    (let ((b (get-buffer-create-1 *perl-buffer-name*))
	  (fs (find-script s)))
      (if (not fs)
	  (message "script %s not found" s)
	(apply 'call-process
	       (nconc
		(list "perl" nil b nil fs)
		(cond ((and (listp args) (eq (car args) 'eval) (list (eval args))))
		       ((listp args) args)
		       (t (list args)))))
	(cond ((eq show 'eval)
	       (set-buffer b)
	       (read (buffer-string)))
	      ((eq show 'split)
	       (set-buffer b)
	       (split (buffer-string) " 	
"))
	      (show (pop-to-buffer b)
		    (beginning-of-buffer))
	      (t
	       (set-buffer b)
	       (buffer-string))
	      )
	)
      )
    )
  )


(defun* perl-command-2 (s &key show args)
  " run immediate perl script S on ARGS" 
  (save-excursion
    (let ((b (get-buffer-create-1 *perl-buffer-name*)))
      (apply 'call-process
	     (nconc
	      (list "perl" nil (list b t) nil "-e" s)
	      (cond ((and (listp args) (eq (car args) 'eval) (list (eval args))))
		    ((listp args) args)
		    (t (list args)))))
      (cond ((eq show 'eval)
	     (set-buffer b)
	     (read (buffer-string)))
	    ((eq show 'split)
	     (set-buffer b)
	     (split (buffer-string) "[ 	
]"))
	    (show (pop-to-buffer b)
		  (beginning-of-buffer))
	    (t
	     (set-buffer b)
	     (buffer-string))
	    )
      )
    )
  )

; (perl-command-2 "map {print \"$_ \"} @ARGV" :show 'split :args '("a" "b" "c"))
; (perl-command-2 "map {print \"$_ \"} @INC" :show 'split)
; (split (perl-command-2 "map {print \"$_ \"} @INC"))
; (loop for x in (perl-command-2 "map {print \"$_ \"} @INC" :show 'split) collect (unix-canonify x 0))

(defun perl-command (s &rest args)
  " run perl script S on ARGS" 
  (save-excursion
    (let* ((b (zap-buffer *perl-buffer-name*))
	   (fs (find-script s)))
      (if (not fs) 
	  (progn (message "warning: script %s not found" s) "")
	(apply 'call-process
	       (nconc
		(list "perl" nil (list b t) nil fs)
		(remove* nil args)))
	(chomp (buffer-string)))
      )
    )
  )

(defun perl-command-region (start end s delete buffer display &rest args)
  " run perl script S on REGION with ARGS.
see call-process-region" 

  (apply 'call-process-region
	 (nconc 
	  (list start end 
		"perl" 
		delete
		buffer 
		display
		(find-script s))
	  args))
  )

;; run perl script on region.  default is same as last time, any if
(defvar *last-perl-script* "")

(defun perl-command-region-1 (script)
  (interactive (list (read-string (format "script (%s): " *last-perl-script*))))
  (let ((p (point))
	(m (mark))
	(b (get-buffer-create "*perl output*"))
	(script (string* (string* script *last-perl-script*)
			 (read-string "script: "))))
    (if (setq *last-perl-script* (string* script))
	(progn
	  (perl-command-region p m script nil b nil)
	  (message (save-excursion (set-buffer b) (buffer-string)))
	  (kill-buffer b)
	  )
      )
    )
  )

(global-set-key "\C-c!" 'perl-command-region-1)

(provide 'perl-command)
