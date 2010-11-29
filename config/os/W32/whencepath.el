(put 'whencepath 'rcsid 
 "$Id: whencepath.el 8 2010-10-05 01:38:57Z svn $")

(require 'cat-utils)
(require 'cl)
(require 'sh)

;; examples
;; (whencepath "ls")
;; (whencepath "other" "HOWTOPATH" t)

(defun whencepath (cmd &optional path regexp executable)
  " look for cmd along path (path is a list of strings)"
  (interactive "scmd: \nspath: ")
  (let* (
	 (default-directory (expand-file-name (getenv "SYSTEMDRIVE")))
	 (abscmd
	  (loop for x in (split-path (getenv (or path "PATH")))
		thereis
		(loop for fx in 
		      (nconc (list (concat x "/" cmd))
			     (unless (or
				      (not (eq window-system 'w32))
				      (string-match "\.exe$" cmd))
			       (list (concat x "/" cmd ".exe"))))
		      when
		      (if regexp
			  (loop for y in (get-directory-files x)
				thereis
				(and (string-match cmd y) (concat x "/" y))
				)
			(if executable
			    (if (-x fx) fx)
			  (if (-f fx) fx))
			)
		      return fx
		      )
		)
	  ))
    (and abscmd
	 (if (interactive-p) (message abscmd) abscmd))
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

(provide 'whencepath)
