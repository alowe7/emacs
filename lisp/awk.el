(put 'awk 'rcsid 
 "$Id: awk.el,v 1.3 2000-10-03 16:50:27 cvs Exp $")


(defvar *last-awk-script* nil)

(defun awk (script) 
  (interactive (list (read-string (format "script (%s): " *last-awk-script*))))

  "run awk on the current region, prompting for script.  this works
around a bug in the win32 implementation of awk that doesn't like to
see \' or \" in the script, but it is generally useful, anyway."

  (let ((fn (mktemp "__awktmp")))

    (if (<= (length script) 0)
	(setq script (or *last-awk-script* (read-string "script: "))))
    (setq *last-awk-script* script)

    (write-region script nil fn nil 0) ; weird feature of write region

    (shell-command-on-region (point) (mark) (format "awk -f %s" fn) "*awk*")
  ;		(delete-file fn)
    )
  )

