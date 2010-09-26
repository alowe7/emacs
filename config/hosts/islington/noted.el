(put 'noted 'rcsid
 "$Id: noted.el,v 1.1 2010-09-26 18:24:41 slate Exp $")

(defvar *notedfile* (expand-file-name "~root/noted"))
(defvar *didfile* (expand-file-name "~root/did"))

(defun noted (arg)
  "add file to `*notedfile*' unless its already there
prompts for filename to add, expanding from `default-directory'.
null means add `buffer-file-name'
with optional prefix arg, just visit `*notedfile*'
"
  (interactive "P")

  (cond
   (arg (find-file *notedfile*))
   (t
    (let* ((insert-default-directory nil)
	   (df (expand-file-name (buffer-file-name)))
	   (f (string* (read-file-name (format "note file (%s): " df) nil nil t) df))
	   (coding-system-for-write 'undecided-unix)
	   )
      (write-region f nil  *notedfile* t 0)
      )
    )
   )
  )

(defun did (&rest args)
  (interactive (list (or current-prefix-arg (read-string "comment: "))))

  (if (listp (car args))
      (find-file *didfile*)
    (let ((coding-system-for-write 'undecided-unix)
	  (text (apply 'glob args))
	  )
      (write-region (format "%s\t%s\t%s\n" (format-time-string "%s") (current-time-string) text) nil  *didfile* t 0)
      )
    )
  )


(provide 'noted)
