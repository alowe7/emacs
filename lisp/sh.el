(put 'sh 'rcsid
 "$Id: sh.el,v 1.1 2004-03-27 19:03:09 cvs Exp $")

(require 'typesafe)
(require 'eval-utils)
(require 'trim)

;; sh -- bain-damaged interpreter for shell scripts
;; by Andy Lowe at TKG, copyright (c) 4/10/1993
;; by Andy Lowe at PSW, copyright (c) 1994, 1995, 1996, 1997, 1998, 1999
;; by Andy Lowe at BroadJump, copyright (c) 2000,2001,2002
;; by Andy Lowe at Motive, copyright (c) 2003,2004

;; ksh-like functions:

;;	 whencepath (cmd path)
;;	 whence (cmd)
;;	 findwhence (cmd)
;;	 dotwhence (cmd)

;;	 scan-file (fn)
;;	 find-function (fn)


(defvar sh-debug nil "set to debug this stuff")
(defvar fw nil)	; first word of last processed line.  usually command
(defvar *shell* "bash")

;;; todo: make like note -- if one-liner, show in minibuffer.

;; (defun findalias (alias)
;;   (let ((al (eval-process "grep" (concat "alias " alias) (concat (getenv "HOME") "/.aliases"))))
;;     (if (and al (> (length al) 0)) (progn
;; 				     (zap-buffer "*alias*")
;; 				     (insert al)
;; 				     (pop-to-buffer "*alias*")
;; 				     t) 
;;       nil)
;;     ))
;; 

(defun findalias (alias)
  (interactive "salias: ")
  (let ((s (clean-string  (eval-process *shell* "-c" (format "alias %s" alias)))))
    (and (string-match "=" s)
	 (substring s (match-end 0) (length s)))
    )
  )

;; examples
;; (findwhence  "tkghours")
;; (findwhence  "src_my_post_change")

(defun findwhence (specified-cmd)
  "find COMMAND along path & suck it into an edit buffer"
  (interactive (list (read-string (format  "command (%s): " (indicated-word)))))
  (let* ((cmd (if (> (length specified-cmd) 0) specified-cmd (indicated-word)))
	 (abscmd (or (whence cmd) (whencepath cmd (catpath "FPATH")))))
    (if abscmd (find-file abscmd)
      (if (not (findalias cmd))
	  (message "%s not found." cmd)))
    )
  )

;; find things along LIBPATH
(defun libwhence (thing)
  (interactive "scommand: ")
  (let ((p (or (getenv "LIBPATH") "/usr/lib/")))
    (dolist (l (catlist p))
      (dolist (x (catlist (eval-process *shell* "-c" (format "echo %s/lib*" l)) ? ))
	(let ((m (eval-process *shell* "-c" (format "nm %s | grep %s" x thing))))
	  (if (> (length m) 0)
	      )
	  )
	))))

(defun dotwhence (cmd)
  "look for cmd on FPATH.  if found, dot it."
  (interactive "scommand: ")
  (let ((a (whencepath "log" (catpath "FPATH"))))
    (scan-file a)))

;; caching paths doesn't work if some interpreted line changes them.
;; optimization: cache globally, & check for mods to paths ?
(defvar path (catpath "PATH"))
(defvar fpath (catpath "FPATH"))

(defun sh-check (thing)
  "if debugging, print out thing & wait."
  (if sh-debug (read-string (format "ignoring: <%s>" thing)))
  )


;; (save-excursion
;;   (let (a) 
;;     (set-buffer (get-buffer-create "*eval*"))
;;     (erase-buffer)
;;     (insert (concat "'(" (catpath "PATH") ")"))
;;     (beginning-of-buffer)
;;     (replace-string "." " " t)
;;     (setq a (eval-current-buffer))
;;     ;;    (kill-buffer current-buffer)
;;     a
;;     )
;;   )



(defun sh-comment (line)
  "ignore comments"
  (sh-check line)
  )

(defun sh-dot  (&optional line)
  " dot the file -- scan it"
  (interactive (list (read-string (format ". (%s):" (bgets)))))
  (let ((line (string* line (bgets))))
    (if (string-match "\.[ 	]*" line)
	(let ((fn (substring line (match-end 0))) fn2)
	  (dolist (x path)
	    (if (-a (setq fn2 ($ (concat x "/" fn))))
		(scan-file fn2)
	      )
	    )
	  )
      )
    )
  )

(defun sh-set (&rest args)
  (dolist (x args)
    (cond 
     ((string= x "-x") (setq sh-debug t))
     ((string= x "+x") (setq sh-debug nil))
  ; ignore anything else
     )
    )
  )

;; example:
;; (sh-dot ". ~/.worlds")

(defun sh-alias (line)
  " a shell alias roughly corresponds to an emacs command.  
this is probably too hard."
  (sh-check line)
  )

(defun handle-dollars (f) 
  (apply 'concat
	 (loop 
	  with l = nil
	  with pos = 0
	  while (string-match "\$[a-zA-Z0-9_]+" f)
	  nconc
	  (prog1
	      (list 
	       (substring f pos (match-beginning 0))
	       (getenv (substring f (1+ (match-beginning 0)) (match-end 0)))
	       )
	    (setq f (substring f (match-end 0))))
	  into l
	  finally return (nconc l (list f)))
	 )
  )
; (handle-dollars "$W/locals")

(defun handle-curlies (s) 
  (let ((p 0) v)
    (loop 
     while (string-match "\${[a-zA-Z0-9_]+}" (substring s p))
     do
     (setq v 
	   (concat v
		   (substring s p (match-beginning 0))
		   (getenv
		    (substring s (+ p (match-beginning 0) 2)
			       (+ p (1- (match-end 0)))))))

     (setq p (match-end 0))
     finally
     (setq v (concat v 
		     (substring s p)))
     )
    v)
  )

;(handle-curlies "${WTOP}w")

(defun $ (path) 
  (join
   (apply 'vector
	  (mapcar 'handle-dollars 
		  (mapcar 'handle-curlies (catlist path ?:))))))
; ($ "${W}/locals")
; ($ "$W/locals")

;; todo: ${foo%bar} ${foo#bar}
;;; ???
(defun $\#\# (var pat)
  " perform ksh equivalent of ${VAR##PAT}"
  (let ((s ($ var)))
    (if (= (string-match pat s) 0)
	(substring s (match-end 0) (length s))
      s)))


(defun $%% (var pat)
  " perform ksh equivalent of ${VAR##PAT}"
  (let ((s ($ var)))
    (if (and (string-match pat s) (= (match-end 0) (length s)))
	(substring s 0 (match-beginning 0))
      s)))

(defun sh-export (line)
  " setenv it.  checks val for $ evaluator" 
  ;; if set -a is used, exports may not be explicit
  ;; if val is a null string, effect is to unset var
  (if (not (string-match "^export[ 	]*" line)) (string-match "^" line))
  (let* ((p (match-end 0))
	 (q (string-match "=" line))
	 (name (substring line p q))
	 (r (match-end 0))
	 (s (string-match "#" line))
	 (val (trim-trailing-white-space (substring line r s))))
    (if (= (length val) 0)
	(setenv name)
      (setenv name ($ val))))
  )


;; example:
;; (sh-export "export LASTWORLD=$WORLD")
;; (sh-export "export foo=bar # ignore this")

;;; todo:
;;; if 1st word is a known command or exec on path, 
;;; then run it with rest of line as args 

(defvar sh-do-echo 1 "if set, interpret echo command as (message ...)
if this is a number, then sit for that many seconds afterward")

(defvar *sh-custom-parser* nil "hook for custom extensions to interpreter for unknown commands
value is a function cell taking the input line to parse.  returns nil if it couldn't parse line.  ")

(defun sh-unknown (line)
  (sh-check (concat "unknown: " line))
  )
;; these can migrate into the interpreter, if necessary
;; 
;; (defun pre_change ()
;;   
;;   (let ((fn (format "%s/bin/%s" (getenv "WHOME") "pre-change")))
;;     (if (file-exists-p fn) (scan-file fn)))
;;   )
;; 
;; (defun post_change ()
;;   
;;   (let ((fn (format "%s/bin/%s" (getenv "WHOME") "post-change")))
;;     (if (file-exists-p fn) (scan-file fn)))
;;   )
;; 

;;(defun my-sh-extension (line)
;;  (let ((fw (string-to-word line)))
;;    (cond
;;     ((string= fw "post_change") (post_change))
;;     ((string= fw "pre_change") (pre_change))
;;     )
;;    )
;;  )

;;(setq *sh-custom-parser* 'my-sh-extension)

(defun sh-function-p (line)
  " true line is not a function"
  (let ((junk (string-to-word line))) ; can't guarantee proximity to last string-match
    (and (< (match-end 0) (length line)) (char-equal ?\( (elt line (1- (match-end 0)))))
    ))

(defun args-from-line (line)
  (let ((junk (string-to-word line))) ; can't guarantee proximity to last string-match
    (or (and (< end-of-word (length line)) ($ (substring line (match-end 0)))) ""))
  )


;; todo:
;; add more shell builtin keywords, particularly "if" "else" "fi" "function", "alias"
;; requires state driver in scan-file
;; handle backquotes

(defun sh-parse-line (line)
  "line contains a complete shell command.  turn it into emacs stuff."
  (if sh-debug (read-string line))

  (let ((linep (trim-leading-white-space line)))
    (if  (> (length linep) 0)
	(let ((fc  (string-to-char linep))
	      fw ) ; don't compute first word unless necessary
	  (cond
	   ((char-equal fc ?#) t) ; (sh-comment linep)
	   ((char-equal fc ?.) (sh-dot linep))
	   ((string= (setq fw (string-to-word linep)) "alias")  (sh-alias linep))
	   ((string= fw "export") (sh-export linep))
  ; won't work for "unset a b c"
	   ((string= fw "unset") (setenv (string-to-word linep 1)))
	   ((and (<= end-of-word (length linep)) 
		 (char-equal (elt linep (1- end-of-word)) ?=)) (sh-export linep))

	   ((string= fw "set") (apply 'sh-set (list (args-from-line line))))

	   ((string= fw "unset") (apply 'setenv (list (args-from-line line))))

					      
	   ((and (string= fw "echo")
		 sh-do-echo)
	    (apply 'message (list (args-from-line line)))
	    (if (numberp sh-do-echo ) (sit-for sh-do-echo)))

	   ((and (functionp *sh-custom-parser*) 
		 (apply *sh-custom-parser* (list fw (args-from-line line)))) t)

	   (t (sh-unknown linep))
	   )
	  )
      )
    )
  )

(defun sh-parse-indicated-line ()
  (interactive)
  (sh-parse-line (indicated-line))
  )

;; example
;;(scan-file "~/.worlds")


;; this way is actually slower, unfortunately
;; (defun scan-file (fn)
;;   "interpret shell script FILE to some extent."
;;   (interactive "ffilename: ")
;;   (dolist (l (catlist (read-file fn) ?
;; 		      ))
;;     (sh-parse-line l)
;;     )
;;   )
;; 

(defun scan-file (fn)
  "interpret shell script FILE to some extent."
  (interactive "ffilename: ")
  (mapcar 'sh-parse-line (split (read-file fn) "
"))
  )

(defun scan-indicated-file ()
  (interactive)
  (scan-file (indicated-word))
  )

(defun scan-current-buffer ()
  (interactive)
  ;; should be something like (sh-eval (buffer-substring (point-min) (point-max)))
  (scan-file (buffer-file-name))
  )

(defun scan-file-p (fn)
  (if (-r fn) (scan-file fn)))


;;; some more hairy shell constructions

(defun ! (x) (not x))

(defun $== (x y) "true if (string= $x  $y)"
  (string= ($ x) y))

(defun $= (x y)
  "setenv x $y" 
  (setenv x ($ y))
  )

(defun $:= (x y)
  "setenv x $y, unless it is already set" 
  (or  (> (length (getenv x)) 0)
       (setenv x ($ y)))
  (getenv x)
  )


(defun -a (x) 
  "THING exists and is a file"
  (and (file-exists-p ($ x)) x))

(defun -f (x) "THING is a file and not a directory"
  (let ((y  ($ x))) (and (file-exists-p y) (not (file-directory-p y)) x))
  )

(defun -x (x) 
  "THING exists, is a non-directory file and is executable"
  (let ((y  ($ x)) attrs)
    (and (file-exists-p y)
	 (not (file-directory-p y))
	 (eq (elt (nth 8 (file-attributes y)) 3) ?x)))
  )


(defun -r (x) 
  "thing is a file"
  ;; todo check file-modes
  (and (file-exists-p ($ x)) x))

(defun -d (x)  "THING is a dir" (and  (file-directory-p ($ x)) x))
(defun -z (x) "THING is null or string of zero length" (or (null x) (= 0 (length ($ x)))))
(defun -n (x) "THING is neither null nor a string of zero length" (not (-z x)))


;; (defun $cat (x) "eval to contents of file in $FILE"  ($ (clean-string (eval-process "cat" ($ x)))))
(defun $cat (x) "eval to contents of  $FILE, evaluating environment vars."  ($ (read-file ($ x))))

(defvar sh-init nil)
(defvar sh-init-hook nil "hook run when this module inits")

(unless sh-init
  (progn  (run-hooks 'sh-init-hook)
	  (setq sh-init t)
	  )
  )

(provide 'sh)
