(put 'whencepath 'rcsid 
 "$Id: whencepath.el,v 1.5 2000-10-30 19:35:54 cvs Exp $")
(require 'ksh-interpreter)
(require 'cl)

(defvar *ext*
  (cond ((eq window-system 'w32) ".exe")
	(t "")))

;; examples
;; (whencepath "ls" (catpath "PATH"))

(defun whencepath (cmd path &optional executable)
  " look for cmd along path (path is a list of strings)"
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

;; examples
;; (whence  "src_my_pre_change")
;; (whence "binlog")

(defun whence (cmd)
  " find COMMAND along path"
  (interactive "scommand: ")
  (let ((abscmd (whencepath cmd (catpath "PATH" window-system) t))
	(fc  (string-to-char cmd)))
    ;; check for ksh function invocation (doesn't work for aliases)
    (if (or (not (string= abscmd cmd)) (char-equal fc ?/) (char-equal fc ?.))
	abscmd
      ;; I think this is a ksh function or alias. check along $FPATH
      (whencepath cmd (catpath "FPATH"))
      )
    )
  )
