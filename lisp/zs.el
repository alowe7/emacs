(defconst rcs-id "$Id: zs.el,v 1.3 2000-07-30 21:03:34 andy Exp $")
(require 'cl)
(require 'indicate)
(require 'eval-process)
;(require 'qsave)
(provide 'zs)

;; cs -- yet another cscope/emacs interface
;; by Andy Lowe (c) 1993, 1994, 1995
;; originally based on cscope.el written by Perry Smith (a.k.a. pedz)
;; at Tandem 
;; Thu Jul 26 10:32:36 CDT 1990

;; this module provides an interface to cscope from emacs.

;;  some of the major features include:
;;  * multiple concurrently active databases.  
;;    stack operations to push, pop & roll cscope contexts
;;  * each scope context includes a stack of the results of queries
;;    made to it, so you can walk up and down the stack and jump to 
;;    any match.  this is a BIG time saver.
;;  * numerous hooks for customization
;;  * tpath searching is optional & uses the same mechanism as viS, 
;;    so you can share cscope databases with viS users.

;; hacked to understand tpath Thu Jun 24 11:38:22 CDT 1993

;; Wed Oct  6 17:26:26 CDT 1993 integrated new features:
;; 1. take default db from $CSDB
;; 2. new hooks: startscope-hook, cscope-after-search-hook
;; 3. add scope stacking functions: roll-scope
;; 4. added *cs-function-keys* 
;; 5. if multiple windows are showing, default goto action is to use other window
;; 6. added pop-to-cscope function
;; 7. added retention of cscope searches

;; Tue 10 19 93 14:39 fixed bug in goto-from-list when > 1000 matches

;; to use:
;;
;;	0. put directory containing this file on your EMACSLOADPATH
;;	   the other packages required above should also be there 
;;	   the cl package should be available with your gnuemacs distribution
;;	   add to your ~/.emacs: 
;;		(autoload 'startscope "cs" nil t)
;;
;;	1. M-x startscope 
;;	   prompts for a directory containing the cscope database.
;;         the database should be made with the following options: 
;;	      cscope -q -b
;;
;;	   if *cscope-use-tpath* is set (the default), files are found along
;;	   your tpath, via tpcscpope.  tpcscope uses the environment
;;	   variable CSTPATH for the search path.  
;;	   
;;	   databases should be built using filenames relative to R2 or com
;;	   (such as those made by mklcs or equivalent)
;;	   
;;	   if this variable is not set, databases should be built using
;;	   absolute filenames or filenames relative to the directory
;;	   containing the database.
;;	   

;;	2. make queries using find- functions.  once loaded, help is on 

(defvar cscope-help-message "
		       ^\\\	startscope
		       ^\\^C	stopscope
		       ^\\^D	find-functions-called
		       ^\\^F	find-func
		       ^\\^H	cscope-help
		       ^\\^I	find-file-include
		       ^\\^J	pop-to-cscope
		       ^\\^M	find-scope-file
		       ^\\^P	find-pattern
		       ^\\^Q	cscope-status
		       ^\\^R	roll-scope
		       ^\\^S	find-assignment
		       ^\\^U	find-callers
		       ^\\^V	prune-cscope-search
		       ^\\^W	pop-scope
		       ^\\^X	swap-scope
		       ^\\^Y	find-symbol
		       ^\\^Z	push-scope
")

;;	   queries usually pick up a default value from the word before 
;;	   point using the indicate package.  to use this feature, just 
;;	   position the cursor on the name of a function, symbol or string
;;	   before calling one of the find- functions.  type-in overrides.
;;
;;	   if cscope-auto-go is non-nil & queries have fewer than cscope-auto-go hits 
;;	   then cs takes you straight to the first hit.  otherwise a menu of hits
;;	   is generated. use the usual positioning commands, e to edit,
;;	   o to edit in the other window, q to remove the menu
;;	   (use -m from inside the menu to get help for this mode.)
;;
;;	3. M-x stopscope (or )

;; 
;;  cs allows multiple active scope databases.  to toggle between them,
;;  use push-scope, pop-scope & swap-scope.  for example:
;; 	1. startscope on database a
;; 	2. push-scope on database b (makes b current, pushes a on stack)
;; 	3. swap-scope (makes a current; pushes b on stack)
;; 	...
;;	4. pop-scope (kills current scope process; pops new one from top of stack)

;;  to query status of running scope processes, call (cscope-status) on 

;; interface variables:
;; 
;;  *cscope-use-tpath*	if set, files are found via TPATH
;;  *cs-function-keys* 	set this if you want function keys defined
;; 			this turns out to be useful when running remotely
;;  cscope-show-status	if set, show status after each stack manipulation
;;  *qsave-cscope-searches* 
;; 			if set, save output of each cscope search on a stack for retrieval
;;  cscope-mode-hook	hook to run when entering cscope mode
;;  cscope-init-hook	hook to run when initializing cscope
;;  startcscope-hook	hook to run when starting a new cscope process
;;  stopcscope-hook	hook to run when stopping a cscope process
;;  cscope-selection-hook	hook to run when selecting a file from a cscope menu
;;  cscope-after-search-hook
;; 			hook to run after each successful search
;; 

;; todo: redefine stack usage -- obviate globals by fns returning top
;; todo -- fns to make/update cscope db
;; todo -- (re-) add mouse support
;; todo -- merge cscope-use-tpath and cscope-tpath var usage

(defvar running-epoch nil)							;default is emacs

;;(defvar *cscope-count* 0 "count of active processes")
(defvar *cscope-process-stack* nil "stack of cscope 3-tuples.")
(defvar *cscope-command* "cscope" "name of cscope or compatible command")
(defvar *cscope-process* nil "current scope process")
(defvar *cscope-query* nil "last query")
(defvar *cscope-buffer* nil "buffer associated with process") 
;; this is redundant with (process-buffer *cscope-process*)
(defvar *cscope-dir* nil "dir current cscope process is running on")

(defvar *cscope-use-tpath-default* nil "default state of *cscope-use-tpath*")
(defvar *cscope-tpath* nil)							;(getenv "CSTPATH")
(defvar *cscope-use-tpath* *cscope-use-tpath-default* "if set, files are found via TPATH.")
(defvar *cscope-trace-cstpath* nil "debug cstpath tracing")

(defvar *qsave-cscope-searches* t 
  "if set, save output of each cscope search on a stack for retrieval")
(defvar cscope-line-vector nil
  "Holds the line numbers for the lines listed in the cscope output")
(defvar cscope-file-vector nil
  "Holds the full path names for the files listed in the cscope output")
(defvar cscope-mode-map nil "")
(defvar cscope-mode-hook nil "hook to run when entering cscope mode")
(defvar cscope-init-hook nil "hook to run when initializing cscope")
(defvar startcscope-hook nil "hook to run when starting a new cscope process")
(defvar stopcscope-hook nil "hook to run when stopping a cscope process")
(defvar cscope-selection-hook nil "hook to run when selecting a file from a cscope menu")

(if *cscope-use-tpath* (require 'cat-utils))

;; emacs-specific initialization. 
(if (string-match "Emacs" (emacs-version))
		(defun fgetenv (x) (getenv x))
	(defun fsetenv (x y) (setenv x y))
	)

;; xxx todo: compute max. width of a request & retain
;; queries as padded to that width
;; may also want to care about width of buffer
(defun cscope-format-mode-line (num total query)
  "formats mode line."
  (setq
   mode-line-process (format " %d/%d" num total)
   mode-line-buffer-identification 
	 (list (concat "%11b: " 
								 (format "%-45s" query))
				 (if *cscope-use-tpath* (if *cscope-trace-cstpath* "(trace-tpath)" "*tpath*"))
				 )))

(defstruct scope-cell 
  "cscope context cell" 
  process buffer dir use-tpath)

(defun push-scope (cscope-dir)
  "push current scope process onto stack and start a new one"
;;  (interactive  "Dcscope-dir: ")
  (interactive (list (file-name-directory (read-file-name "cscope-dir: "  (getenv "CSDB") nil t))))
  (if *cscope-process* 
      (let ((x (make-scope-cell :process *cscope-process*
				:buffer *cscope-buffer*
				:dir *cscope-dir*
				:use-tpath (and *cscope-use-tpath* (or *cscope-tpath*  (getenv "CSTPATH"))))))
	(push x *cscope-process-stack*)
	(setq *cscope-process* nil
	      *cscope-buffer* nil
	      *cscope-dir* nil
	      *cscope-use-tpath* *cscope-use-tpath-default*
	      )
	)
    )
  (startscope cscope-dir)
  )

(defun kill-this-scope ()
  " current buffer is associated with a scope process. 
  kill that process; then kill this buffer"
  (interactive)
  (while (and (not (eq *cscope-buffer* (current-buffer))) (roll-scope)))
  (if (eq *cscope-buffer* (current-buffer))
      (progn
	(kill-buffer (current-buffer))
	(pop-scope)))
  )

(defun pop-scope ()
  "make top of stack current scope focus"
  (interactive)
  (if *cscope-process* (stopscope))
  (if *cscope-process-stack* 
      (let ((r (pop *cscope-process-stack*)))
	(setq *cscope-process* (scope-cell-process r)
	      *cscope-buffer* (scope-cell-buffer r)
	      *cscope-dir* (scope-cell-dir r)
	      *cscope-use-tpath* (scope-cell-use-tpath r))
	)
    (setq *cscope-process* nil
	  *cscope-buffer* nil
	  *cscope-dir* nil
	  *cscope-use-tpath* nil)
    )
  (cscope-maybe-show-status)
  )

(defun cscope-goto-getnum (v &optional arg)
  (cscope-goto-num (getnumber v) arg)
  )


(defun cscope-key-help () (interactive)
	(help-for-map cscope-mode-map)
	)

(defvar cscope-mode-syntax-table nil)
(defun cscope-mode ()
  "Major mode used to look at the cscope output stuff.
	runs cscope-mode-hook

Type:
  n to go to the next search context, if any
  p to go to the previous search context, if any
  Space to go to the next line
  Backspace to go to the previous line
  v to view the file and line
  e to edit the file at the line
  o to edit the file at the line in other window
  <numeric digits>RET to edit the file at corresponding line
  q to delete the cscope window

 invoke cscope-key-help for key definitions
"
  (use-local-map cscope-mode-map)
			 (if cscope-mode-syntax-table
			     (set-syntax-table cscope-mode-syntax-table)
			   (progn
			     (setq cscope-mode-syntax-table (make-syntax-table))
					 (modify-syntax-entry ?_ "w" cscope-mode-syntax-table)
					 (modify-syntax-entry ?< "." cscope-mode-syntax-table)
					 (modify-syntax-entry ?> "." cscope-mode-syntax-table)
					 ))
  (setq truncate-lines t)
  (setq major-mode 'cscope-mode)
  (setq mode-name "C-Scope")
;;  (x-add-cscope-mouse) ; remove if not using mighty-mouse
;; todo -- add epoch mouse support (e.g. double-click on entry=goto)
  (run-hooks 'cscope-mode-hook)
  )

(defun cscope-get-line-number ()
  "Returns the \"line number\" out of a cscope output buffer"
  (end-of-line)
  (re-search-backward "^[ 0-9][ 0-9][0-9]+")
  (1- (string-to-int (buffer-substring (match-beginning 0) (match-end 0)))))

(defvar cscope-last-show-from-list nil 
"holds expanded result of last call to (cscope-show-from-list)
 function (cscope-last-show-from-list) inserts this value after point
")

(defun cscope-show-from-list ( &optional arg )
  "Point is in a buffer pointing to a line produced by cscope-list-line.
 This routine displays the full path name of the indicated file
 optional arg LINE specifies the target line from current buffer to use
 (default=current line)
 The value of the variable cscope-last-show-from-list holds the expanded file name.
"
  (interactive "P")
  (if arg
      (goto-line (prefix-numeric-value arg)))
  (condition-case fn
      (message (setq cscope-last-show-from-list
										 (cs-expand-file-name (aref cscope-file-vector (cscope-get-line-number)))))
    (error (progn  (setq cscope-last-show-from-list (cadr fn))
									 (message "File <%s> not found" (cadr fn))))
    )
  )

(defun cscope-goto-from-list ( &optional arg )
  "Point is in a buffer pointing to a line produced by cscope-list-line.
 This routine pops into the file at the appropriate spot
 with optional ARG, switch to buffer in other window
"
  (interactive "P")

  (condition-case fn
			(let* ((num (cscope-get-line-number))
						 (fname (cs-expand-file-name (aref cscope-file-vector num)))
						 (lnum (aref cscope-line-vector num))
						 (b (find-file-noselect fname)))
			  (if arg (pop-to-buffer b) (switch-to-buffer b))
				(goto-line lnum))
		(error (message "File <%s> not found" (cadr fn)))
		)

  )

(defvar  *cscope-goto-other-window* nil
  "select target window when goto-other-window from cscope list")

(defun cscope-goto-from-list-other-window ( &optional arg )
  "Point is in a buffer pointing to a line produced by
cscope-list-line. This routine plops into the file at the appropriate
spot"
  (interactive "P")
  (if arg
      (goto-line (prefix-numeric-value arg)))
  (condition-case fn
      (let* ((w (selected-window))
	     (num (cscope-get-line-number))
	     (fname (cs-expand-file-name (aref cscope-file-vector num)))
	     (lnum (aref cscope-line-vector num)))
	(find-file-other-window fname)
	(goto-line lnum)
	(if running-epoch (highlight-line))
	(if *cscope-goto-other-window*
	    (select-window w))
	)
    (error (message "File <%s> not found" (cadr fn)))
    )
  )


(defun cscope-goto-num (arg &optional other-buffer)
  "Point is in a buffer pointing to a line produced by
cscope-list-line. This routine plops into the file at the appropriate
spot"
  (interactive "nNumber: ")
  (condition-case fn
      (let* ((num (1- arg))
	     (fname (cs-expand-file-name (aref cscope-file-vector num)))
	     (lnum (aref cscope-line-vector num)))
	(if other-buffer
	    (find-file-other-window fname)
	  (find-file fname))
	(goto-line lnum))
    (error (message "File <%s> not found" (cadr fn)))
    )
  )

(defun cscope-view-from-list ()
  "Point is in a buffer pointing to a line produced by
cscope-list-line. This routine plops into the file at the appropriate
spot"
  (interactive)
  (condition-case fn
      (let* ((num (cscope-get-line-number))
	     (fname (cs-expand-file-name (aref cscope-file-vector num)))
	     (lnum (aref cscope-line-vector num)))
	(save-excursion
	  (find-file fname)
	  (goto-line lnum)
	  (view-buffer (current-buffer))))
    (error (message "File <%s> not found" (cadr fn)))
    )
  )

(defun next-cscope-hit () 
  (interactive)
  (next-line 1)
  (cscope-goto-from-list-other-window)
  )

(defun cscope-wait ()
  "Waits for the cscope process to finish"
  (message "Waiting for cscope...")
  (while (and (eq (process-status *cscope-process*) 'run)
	      (progn
		(goto-char (point-max))
		(beginning-of-line)
		(not (looking-at ">> "))))
    (accept-process-output *cscope-process*))
  (message ""))

;; XXX
(defun zmat (s pat)
  " perform lisp equivalent of ${VAR##PAT}"
	(let ((m (string-match pat s)))
    (if (null m) s
		(if (= m 0)
				(substring s (match-end 0) (length s))
      s))))

(defun delete-line (&optional n)
"delete current line
with optional ARG, delete that many lines
"
  (let (( x (progn (beginning-of-line) (point))))
    (forward-line (or n 1))
    (beginning-of-line)
    (delete-region x (point))
    ))

(defun cscope-format ()
  "Formats the output of cscope to be pretty"
  (let ((longest-file 0)
				(longest-function 0)
				(longest-line 0)
				(counter 0)
				pat return-value)
    (goto-char (point-max))
    (beginning-of-line)
    (kill-line 1)
    (goto-char (point-min))
    (kill-line 1)
    (while (re-search-forward "^\\([^ ]+\\) \\([^ ]+\\) \\([^ ]+\\) \\(.*\\)"
															nil t)
      (let ((filename (file-name-nondirectory
											 (buffer-substring (match-beginning 1) (match-end 1))))
						(function (buffer-substring (match-beginning 2) (match-end 2)))
						(linenum (buffer-substring (match-beginning 3) (match-end 3)))
						(other (buffer-substring (match-beginning 4) (match-end 4)))
						temp)
				(if (> (setq temp (length filename)) longest-file)
						(setq longest-file temp))
				(if (> (setq temp (length function)) longest-function)
						(setq longest-function temp))
				(if (> (setq temp (length linenum)) longest-line)
						(setq longest-line temp))
				(setq counter (1+ counter))))
    (setq cscope-file-vector (make-vector counter ""))
    (setq cscope-line-vector (make-vector counter 0))
    (setq return-value counter)
    (setq counter 0)
    (goto-char (point-min))
    (while (re-search-forward "^\\([^ ]+\\) \\([^ ]+\\) \\([^ ]+\\) \\(.*\\)"
															nil t)
      (let* ((full-filename
							(buffer-substring (match-beginning 1) (match-end 1)))		       
						 (function (buffer-substring (match-beginning 2) (match-end 2)))
						 (linenum (buffer-substring (match-beginning 3) (match-end 3)))
						 (other (buffer-substring (match-beginning 4) (match-end 4)))
						 (filename (file-name-nondirectory full-filename))
						 (filelen (length filename))
						 (funclen (length function))
						 (temp (format "%%3d %%s%%%ds%%s%%%ds%%%ds %%s"
													 (1+ (- longest-file filelen))
													 (1+ (- longest-function funclen))
													 longest-line)))
				(aset cscope-file-vector counter full-filename)
				(aset cscope-line-vector counter (string-to-int linenum))
																				; XXX
																				;				(replace-match (format temp (setq counter (1+ counter))
																				;															 filename " " function " " linenum
																				;															 other))
				(delete-region (match-beginning 0) (match-end 0))
				(insert (format temp (setq counter (1+ counter))
												(if *cscope-use-tpath* 
														(zmat full-filename 
																	(format "%s/prod/src" (fgetenv "PROD")))
													filename)
												" " function " " linenum
												other))
				))
    (goto-char (point-min))
    ;;  don't break up lines.  let (wrap) handle that if necessary
    ;;    (setq pat (concat "\\("
    ;;		      (make-string (- (window-width) 2) ?.)
    ;;		      "\\)\\(.+\\)"))
    ;;    (while (re-search-forward pat nil t)
    ;;      (replace-match (concat
    ;;		      (buffer-substring (match-beginning 1) (match-end 1))
    ;;		      "\n"
    ;;		      (make-string
    ;;		       (+ longest-file longest-function longest-line 7) ? )
    ;;		      (buffer-substring (match-beginning 2) (match-end 2))))
    ;;      (beginning-of-line))
    ;;
    (goto-char (point-min))
    return-value))

(defconst cscope-auto-go 1
  "When fewer than cscope-auto-go entries are found, emacs automatically selects the first one.
if cscope-auto-go is negative, select the last one.
")

(defun cscope-find-goodies ( string )
  "Calls the cscope program and sends it STRING, plops into the buffer
and puts the buffer into cscope-mode"
  (interactive "sString: ")
  ;;  (cscope-init-process)
  (set-buffer *cscope-buffer*)
  (setq buffer-read-only nil)
  (erase-buffer)
  (send-string *cscope-process* string)
  (cscope-wait)
  (let ((v (cscope-format)))
    (if (zerop v)
				(message "no cscope hits.")
      (progn
				;; found at least one hit
				(qsave-cscope-search *cscope-buffer*)
				(setq buffer-read-only t)
				(run-hooks 'cscope-after-search-hook)
				;; briefly: if cscope-auto-go is nil or 0, just pop to cscope buffer.
				;; else if its positive, auto-go to (max cscope-auto-go n) hit, where n is the number of hits
				;; else if negative, auto-go as above, but use (min (- n cscope-auto-go) 1)
					(cond ((or (zerop cscope-auto-go) (> v (abs cscope-auto-go)))
								 (pop-to-buffer *cscope-buffer*))
								((> cscope-auto-go 0)
								 (progn (goto-char 1)
												(forward-line (1- cscope-auto-go))
												(cscope-goto-from-list)))
								(t
								 (progn (goto-char (point-max))
												(forward-line cscope-auto-go)
												(cscope-goto-from-list)))
					)
				)
			)
		)
	)

(defun find-symbol ( string )
  "Find all references to the symbol"
  (interactive (list (read-string (format "symbol (%s): " (indicated-word)))))
  (let ((word (or (and (> (length string) 0) string)  (indicated-word))))
    (setq *cscope-query* (format "symbol(%s) " word))
    (cscope-find-goodies (concat "0" word "
"))))

(defun find-func ( string )
  "Find a definition (function, type declaration or a #define using the cscope stuff"
  (interactive (list (read-string (format "function (%s): " (indicated-word)))))
  (let ((word (or (and (> (length string) 0) string)  (indicated-word))))
    (setq *cscope-query* (format "function(%s) " word))
    (cscope-find-goodies (concat "1" word "
"))))

(defun find-functions-called ( string )
  "Find all functions called by this function"
  (interactive (list (read-string (format "calls from (%s): " (indicated-word)))))
  (let ((word (or (and (> (length string) 0) string)  (indicated-word))))
    (setq *cscope-query* (format "calls from(%s) " word))
    (cscope-find-goodies (concat "2" word "
"))))

(defun find-callers ( string )
  "Find all calls to the function"
  (interactive (list (read-string (format "calls to (%s): " (indicated-word)))))
  (let ((word (or (and (> (length string) 0) string)  (indicated-word))))
		(if (string= "." word)							; special case includers of current routine
				(let ((v))
					(setq word (save-excursion
											 (beginning-of-defun)
											 (cond 
												((eq major-mode 'c-mode) (backward-list 1))
												((eq major-mode 'emacs-lisp-mode) (progn
																														(down-list 1)
																														(forward-word 2)))
												)
											 (indicated-word)))
					(or (y-or-n-p (format "find callers of %s? " word))
							(throw 'done t))
					)
			)
    (setq *cscope-query* (format "callers(%s) " word))
    (cscope-find-goodies (concat "3" word "
"))))

(defun find-assignment ( string )
  "Find assignment to variable using cscope stuff"
  (interactive (list (read-string (format "assignment to (%s): " (indicated-word)))))
  (let ((word (or (and (> (length string) 0) string)  (indicated-word))))
    (setq *cscope-query* (format "string(%s) " word))
    (cscope-find-goodies (concat "4" word "
"))))

(defun find-pattern ( string )
  "Finds egrep patter in cscope stuff"
  (interactive (list (read-string (format "pattern (%s): " (indicated-word)))))
  (let ((word (or (and (> (length string) 0) string)  (indicated-word))))
    (setq *cscope-query* (format "pattern(%s) " word))
    (cscope-find-goodies (concat "6" word "
"))))

(defun find-scope-file ( string )
  "Finds files matching PATTERN"
  (interactive (list (read-string (format "file (%s): " (indicated-word)))))
  (let ((word (or (and (> (length string) 0) string)  (indicated-word))))
    (setq *cscope-query* (format "files(%s) " word))
    (cscope-find-goodies (concat "7" word "
"))))

(defun find-file-include ( string )
  "Find the files which include the file matching PATTERN"
  (interactive (list (read-string (format "includers (%s): " (indicated-word)))))
  (let ((word (or (and (> (length string) 0) string)  (indicated-word))))
		(if (string= "." word)							; special case includers of current module
				(setq word (file-name-nondirectory (buffer-file-name))))
    (setq *cscope-query* (format "includers(%s) " word))
    (cscope-find-goodies (concat "8" word "
"))))

(defun cscope-help ()
  (interactive)
  (if (eq major-mode 'cscope-mode) 
      (describe-mode)
    (progn
      (pop-to-buffer "*Help*")
      (erase-buffer)
      (insert cscope-help-message)
      (beginning-of-buffer)
      )
    )
  )

(defvar cs-status-buffer-name "*Status*")

;; todo: modify process stack stuff to call this guy when a window 
;; showing buffer is visible

(defun cscope-status ()
  " show status of running processes"
  (interactive) 
  (if *cscope-process-stack*
      (progn
				(pop-to-buffer (zap-buffer  cs-status-buffer-name))
				(let ((p (process-list))
							(pid (and (processp *cscope-process*)
												(eq (process-status *cscope-process*) 'run)
												(process-id *cscope-process*))))
					(dolist (x p)
						(let ((c (process-command x)))
							(and (string= (car c) "cscope")
									 (let ((s (process-status x))
												 (f (save-excursion (set-buffer (process-buffer x)) default-directory)))
						 
										 (insert (format "%c %s %s %s\n"
																		 (if (eq pid (process-id x)) ?* ? )
																		 (apply 'concat (mapcar '(lambda (x) (concat x " ")) c))
																		 (if (string= f (fgetenv "CSCOPESDIR"))
																				 (caddr c)
																			 f)
																		 s))
										 )))))
				(set-buffer-modified-p nil)
				)
    (let* ((b (get-buffer cs-status-buffer-name))
					 (w (and b (get-buffer-window b))))
      (and w (delete-window w))
      (and b (kill-buffer b))
      (if (and (processp *cscope-process*) 
							 (eq (process-status *cscope-process*) 'run))
				(message (if (string= *cscope-dir* (fgetenv "CSCOPESDIR"))
														 (format "cscope running on %s" (caddr (process-command *cscope-process*)))
														 *cscope-dir*))
								 (message "no cscope process found")))
    )
  )


;; this uses the function key definitions sometimes seen on vt100 emulators. 
;; your mileage may vary.
;;(defun cscope-keys ()
;;  (define-key global-map "OP" 'cscope-help)
;;  (define-key global-map "OQ" 'find-symbol)
;;  (define-key global-map "OR" 'find-func)
;;  (define-key global-map "OS" 'find-functions-called)
;;  (define-key global-map "OT" 'find-callers)
;;  (define-key global-map "OU" 'find-assignment)
;;  (define-key global-map "OV" 'find-pattern)
;;  (define-key global-map "OW" 'find-scope-file)
;;  (define-key global-map "OX" 'find-file-include)
;;  (define-key global-map "s" 'cscope-status)
;;  (define-key global-map "OY" 'stopscope)
;;  ""
;;  )

(defun startscope (cscope-dir)
  "start up a new cscope process.
 arg CSCOPE-DIR is the full pathname of the directory containing the database 
default is taken from environment variable CSDB, or pwd if that is not set.
"
  (interactive (list (read-file-name "cscope-dir: " (getenv "CSDB")  nil t)))

  (or (and *cscope-process* (eq (process-status *cscope-process*) 'run))
      (progn
;;	(if (buffer-exists-p "*cscope*") (kill-buffer "*cscope*"))
;;	(setq *cscope-count* (1+ *cscope-count*));
;;	(setq *cscope-buffer-name* (format "*cscope%d*" *cscope-count*))

;; do it this way, so default is to use tpath, but a world can turn it off
	(setq *cscope-use-tpath* (not (string= (getenv "CSCOPE_TPATH") "no")))
	(setq *cscope-tpath* (and  *cscope-use-tpath* (getenv "CSTPATH")))
	(setq cscope-auto-go (let ((csag (getenv "CSCOPE_AUTOGO"))) (if csag (string-to-int csag) 1)))
	(setq *cscope-buffer-name* cscope-dir)
	(setq *cscope-buffer* (get-buffer-create *cscope-buffer-name*))
	(set-buffer  *cscope-buffer*)
	(cscope-mode)
	(cd (setq *cscope-dir* cscope-dir))
	(setq *cscope-process* (start-process "scope" *cscope-buffer* *cscope-command* "-q" "-d" "-l"))
	(cscope-wait)
;; if you like function keys, do this.
;;	(cscope-keys)
	)
      )
  )

(defun stopscope ()
  "exit cscope process, if running"
  (interactive)
  (and (eq (process-status *cscope-process*) 'run)
       (send-string *cscope-process* "q")
       )
  (run-hooks 'stopscope-hook)
  )

(setq cscopes-db-vector '(
			  ("adf.allsrc.db")
			  ("adf.db")
			  ("aic.allsrc.db")
			  ("aic.db")
			  ("allsf.allsrc.db")
			  ("allsf.db")
			  ("allsf3.db")
			  ("bitternut.allsrc.db")
			  ("bitternut.db")
			  ("blkmux.allsrc.db")
			  ("blkmux.db")
			  ("bos.allsrc.db")
			  ("bos.db")
			  ("cmdtext.allsrc.db")
			  ("cmdtext.db")
			  ("commo.allsrc.db")
			  ("commo.db")
			  ("dcecma.allsrc.db")
			  ("dcecma.db")
			  ("dsmit.allsrc.db")
			  ("dsmit.db")
			  ("em78.allsrc.db")
			  ("em78.db")
			  ("escon.allsrc.db")
			  ("escon.db")
			  ("fcs.allsrc.db")
			  ("fcs.db")
			  ("fddi.allsrc.db")
			  ("fddi.db")
			  ("gos.allsrc.db")
			  ("gos.db")
			  ("hcon.allsrc.db")
			  ("hcon.db")
			  ("icraft.allsrc.db")
			  ("icraft.db")
			  ("info.allsrc.db")
			  ("info.db")
			  ("lz1.allsrc.db")
			  ("lz1.db")
			  ("mpa.allsrc.db")
			  ("mpa.db")
			  ("ncs.allsrc.db")
			  ("ncs.db")
			  ("nep.allsrc.db")
			  ("nep.db")
			  ("netware.allsrc.db")
			  ("netware.db")
			  ("nfs.allsrc.db")
			  ("nfs.db")
			  ("ntwkmgmt.allsrc.db")
			  ("ntwkmgmt.db")
			  ("pcsim.allsrc.db")
			  ("pcsim.db")
			  ("perf.allsrc.db")
			  ("perf.db")
			  ("perf12.allsrc.db")
			  ("perf12.db")
			  ("r5gos.allsrc.db")
			  ("r5gos.db")
			  ("r5xmgr.allsrc.db")
			  ("r5xmgr.db")
			  ("tcpip.allsrc.db")
			  ("tcpip.db")
			  ("tenplus.allsrc.db")
			  ("tenplus.db")
			  ("tw.allsrc.db")
			  ("tw.db")
			  ("xmgr.allsrc.db")
			  ("xmgr.db")
			  )
      )

(defun get-cscopes-db ()
  (let ((p (getenv "PROD")))
    (expand-file-name (completing-read "csdb: " cscopes-db-vector nil nil (and p (concat p ".db")))
		      (getenv "CSCOPESDIR")
		      ))
  )


;;;   like push-scope, but uses public databases
(defun cscopes (cscope-fn)
  "start up a new cscope process.
 arg CSCOPE-FN is the pathname of a file containing the database 
default is taken from environment variable PROD.
files are searched for in directory \$CSCOPESDIR
"
  (interactive (list (get-cscopes-db)))

  (if *cscope-process* 
      (let ((x (make-scope-cell :process *cscope-process*
																:buffer *cscope-buffer*
																:dir *cscope-dir*
																:use-tpath *cscope-use-tpath*)))
				(push x *cscope-process-stack*)
				(setq *cscope-process* nil
							*cscope-buffer* nil
							*cscope-dir* nil
							*cscope-tpath* nil
							*cscope-use-tpath*  *cscope-use-tpath-default*
							)
				)
    )
  (let ((cscope-dir (file-name-directory cscope-fn)))
		(if (not (file-directory-p cscope-dir)) 
				(message "cs: cannot find directory %s" cscope-dir)
			(or (and *cscope-process* (eq (process-status *cscope-process*) 'run))
					(progn
						;;	(if (buffer-exists-p "*cscope*") (kill-buffer "*cscope*"))
						;;	(setq *cscope-count* (1+ *cscope-count*));
						;;	(setq *cscope-buffer-name* (format "*cscope%d*" *cscope-count*))

						;; do it this way, so default is to use tpath, but a world can turn it off
						(setq *cscope-use-tpath* (not (string= (getenv "CSCOPE_TPATH") "no")))
						(setq cscope-auto-go (let ((csag (getenv "CSCOPE_AUTOGO"))) (if csag (string-to-int csag) 1)))
						(setq *cscope-buffer-name* cscope-fn)
						(setq *cscope-buffer* (get-buffer-create *cscope-buffer-name*))
						(set-buffer  *cscope-buffer*)
						(cscope-mode)
						(cd (setq *cscope-dir* cscope-dir))
						(setq *cscope-process* (start-process "scope" *cscope-buffer* *cscope-command* "-f" cscope-fn "-q" "-d" "-l"))
						(cscope-wait)
						;; if you like function keys, do this.
						;;	(cscope-keys)
						)
					)
			)
    )
  )

(defvar *cs-function-keys* nil "set this if you want function keys defined")

(if *cs-function-keys*
    (progn
      (define-key help-map "" 'cscope-help)
      (define-key global-map "OP" 'startscope)
      (define-key global-map "OQ" 'cscope-status)
      (define-key global-map "OR" 'find-symbol)                
      (define-key global-map "OS" 'find-func)                  
      (define-key global-map "OT" 'find-functions-called)      
      (define-key global-map "OU" 'find-callers)               
      (define-key global-map "OV" 'find-assignment)                
      (define-key global-map "OW" 'find-pattern)               
      (define-key global-map "OX" 'find-scope-file)            
					; (define-key global-map "OX" 'find-file-include)          
      (define-key global-map "OY" 'stopscope)

      (define-key global-map "OZ" 'push-scope)
      (define-key global-map "OO" 'pop-scope)

      (setq cscope-help-message "

  cscope function key definitions:


	F1       startscope
	F2       cscope-status
	F3       find-symbol             
	F4       find-func               
	F5       find-functions-called   
	F6       find-callers            
	F7       find-assignment
	F8       find-pattern            
	F9       find-scope-file         
	F10      stopscope

	F11      push-scope
	F12      pop-scope
")

      t)
  )

(defvar cscope-show-status nil "show status after each stack manipulation")

(defun cscope-maybe-show-status ()
  (if (or cscope-show-status 
	  (let ((b (get-buffer cs-status-buffer-name)))
	    (and b (get-buffer-window b)))
	  (null *cscope-buffer*))
	  (cscope-status)
    (message "cscope running on: %s" (buffer-name *cscope-buffer*))
    )
  )

(defun roll-scope ()
  "roll scope stack"
  (interactive)
  (if *cscope-process-stack* 
      (let (ss r)
	(while  *cscope-process-stack* (push (pop *cscope-process-stack*) ss))
	(push (make-scope-cell :process *cscope-process*
			       :buffer *cscope-buffer*
			       :dir *cscope-dir*
			       :use-tpath *cscope-use-tpath*) ss)
	(while ss (push (pop ss) *cscope-process-stack*))
	(setq r (pop *cscope-process-stack*))
	(setq *cscope-process* (scope-cell-process r)
	      *cscope-buffer* (scope-cell-buffer r)
	      *cscope-dir* (scope-cell-dir r)
	      *cscope-use-tpath* (scope-cell-use-tpath r))
	(cscope-maybe-show-status)
	t)
    (progn
      (message "scope stack is empty")
      nil)
    )
  ) 

;; add definition for roll scope to keymap & help message
;; unless using function keys

(defun swap-scope ()
  "swap current scope with top of stack"
  (interactive)
  (if *cscope-process-stack* 
      (let ((p (make-scope-cell :process *cscope-process*
				:buffer *cscope-buffer*
				:dir *cscope-dir*
				:use-tpath *cscope-use-tpath*))
	    (r (pop *cscope-process-stack*)))
	(push p *cscope-process-stack*)
	(setq *cscope-process* (scope-cell-process r)
	      *cscope-buffer* (scope-cell-buffer r)
	      *cscope-dir* (scope-cell-dir r)
	      *cscope-use-tpath* (scope-cell-use-tpath r))
	(cscope-maybe-show-status)
	)
    (message "scope stack is empty")
    )
  )


(defun cs-expand-file-name (fn)
  " expands FILENAME according to setting of *cscope-use-tpath*"
  (interactive)
  (prog1 
      (if *cscope-use-tpath*
	  (or (let ((f))
		(catch 'done
;; if *cscope-tpath* is a list, use it as a tpath list should be of the form: ("d1" "d2" ...)
;; if it is a string, assume of the form "d1:d2:..." and make it a list of strings first.
;; otherwise, use the CSTPATH env. var
		  (dolist (x (if (and (listp *cscope-tpath*) (not (null *cscope-tpath*))) *cscope-tpath*
			   (if (stringp  *cscope-tpath*) (catlist *cscope-tpath*) (catpath "CSTPATH"))))
		    (setq f (expand-file-name (concat x  "/" fn)))
		    (if *cscope-trace-cstpath* (read-string f))
		    (and (file-exists-p f) (throw 'done f))))) 
	      (signal 'error (list fn)))
	    (if (file-exists-p fn) 
		fn
		 (signal 'error (list fn)))
	)
    ;;	  (clean-string (eval-process "mtpcscope" fn))

    (run-hooks 'cscope-selection-hook))
  )

;; this doesn't work
;; 	  (replace-letter (eval-process "mtpcscope" fn) "ÿ" "")
;; (defun cs-expand-file-name (fn)
;;   " expands FILENAME according to setting of *cscope-use-tpath*"
;;   (interactive)
;;   (let ((v (if *cscope-use-tpath*
;; 	       (clean-string (eval-process "mtpcscope" fn))
;; 	     (expand-file-name fn))) 
;; 	tv)
;;     (if (string= v fn);; tpath didn't find it.
;; 	(if (catch 'done
;; 	      (dolist (x (list (getenv "B") (getenv "NFSGOS") (getenv "NFSBOS")))
;; 		(dolist (y (list "com" "R2"))
;; 		  (setq tv (format "%s/%s/%s" x y v))
;; ;		  (read-string tv)
;; 		  (if (file-exists-p tv)
;; 		      (throw 'done tv))
;; 		  ))) tv
;; 	  (message "cannot find %s" v))
;;       (run-hooks 'cscope-selection-hook))
;;     tv
;;       )
;;   )


(defun pop-to-cscope  ( &optional arg )
" jump to current cscope buffer"
  (interactive "P")

  (and *cscope-buffer* 
       (if arg (switch-to-buffer *cscope-buffer*) (pop-to-buffer *cscope-buffer*)))
  )


(if (not (fboundp 'ctl-\-prefix)) 
    (define-prefix-command 'ctl-\-prefix)) ;; don't wipe out map if it already exists
;; (global-unset-key "" )
(global-set-key "" 'ctl-\-prefix)
(let ((map (symbol-function  'ctl-\-prefix))) ;; do redefine keys, tho.
  (define-key map "" 'startscope)
  (define-key map "" 'cscope-help)
  (define-key map "" 'find-symbol)
  (define-key map "" 'find-func)
  (define-key map "" 'find-functions-called)
  (define-key map "" 'find-callers)
  (define-key map "" 'find-assignment)
  (define-key map "" 'find-pattern)
  (define-key map "" 'find-scope-file)
  (define-key map "	" 'find-file-include)
  (define-key map "" 'cscope-status)
  (define-key map "