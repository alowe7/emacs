(put 'whencepath 'rcsid 
 "$Id: whencepath.el,v 1.8 2003-02-23 23:41:54 cvs Exp $")
(require 'ksh-interpreter)
(require 'cat-utils)
(require 'cl)

;; examples
;; (whencepath "ls")
;; (whencepath "other" "HOWTOPATH" t)

(defun whencepath (cmd &optional path regexp executable)
  " look for cmd along path (path is a list of strings)"
  (interactive "scmd: \nspath: ")
  (let ((abscmd
	 (loop for x in (split (getenv (or path "PATH")) ":")
	       thereis
	       (let ((fx (concat x "/" cmd)))
		 (if regexp
		   (loop for y in (get-directory-files x)
			 thereis
			 (and (string-match cmd y) (concat x "/" y))
			 )
		     (if executable
			 (if (-x fx) fx)
		       (if (-f fx) fx))
		   )
		 )
	       )
	 ))
    (and abscmd
	 (if (interactive-p) (message abscmd) abscmd))
    )
  )

(defun whencepath1 (cmd path &optional executable)
  " look for cmd along path (path is a list of strings)"
  (let ((*ext* (or (and (eq window-system 'w32) ".exe") "")))

    (loop for x in path
	  with test = (if executable '-x '-f)
	  with fn
	  when (or 
		(and (setq fn (format "%s/%s%s" x cmd *ext*))
		     (funcall test fn))
		(and (eq window-system 'w32)
		     (setq fn (format "%s/%s" x cmd))
		     (funcall test fn)))
	  return (expand-file-name fn)
	  )
    )
  )

;; examples
;; (whence  "src_my_pre_change")
;; (whence "binlog")

(defun whence (cmd)
  " find COMMAND along path"
  (interactive "scommand: ")
  (let ((abscmd (whencepath cmd "PATH"))
	(fc  (string-to-char cmd)))
    ;; check for ksh function invocation (doesn't work for aliases)
    (if (or (not (string= abscmd cmd)) (char-equal fc ?/) (char-equal fc ?.))
	abscmd
      ;; I think this is a ksh function or alias. check along $FPATH
      (whencepath cmd "FPATH")
      )
    )
  )

; (whencepath "la")

(defun find-whence (cmd)
  " find COMMAND along path"
  (interactive "scommand: ")
  (let ((abscmd (whencepath cmd)))
    (if abscmd 
	(find-file abscmd) 
      (message "%s not found" abscmd)
      )
    )
  )
