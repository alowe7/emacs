(put 'noted 'rcsid
 "$Id: noted.el,v 1.2 2010-09-27 01:28:23 slate Exp $")

(require 'fb)
(defvar *notedfile* (expand-file-name "~root/noted"))
(defvar *didfile* (expand-file-name "~root/did"))

(define-derived-mode noted-mode fb-mode "*noted*"
)

(defun noted (arg)
  "add file to `*notedfile*' unless its already there
prompts for filename to add, expanding from `default-directory'.
null means add `buffer-file-name'
with optional prefix arg, just visit `*notedfile*'
"
  (interactive "P")

  (cond
   (arg
    (let* ((b (get-file-buffer *notedfile*))
	   (w (and b (buffer-live-p b) (get-buffer-window b))))
      (cond
       (w (select-window w))
       ((and b (buffer-live-p b)) (switch-to-buffer b))
       (t
	(find-file *notedfile*)
	(noted-mode)))
      )
    )
   (t
    (let* ((insert-default-directory nil)
	   (df (expand-file-name (buffer-file-name)))
	   (f (string* (read-file-name (format "note file (%s): " df) nil nil t) df))
	   (coding-system-for-write 'undecided-unix)
	   )

      (cond
       ((= 0 (call-process "grep" nil nil nil "-q" f *notedfile*))
	(message "file %s is already noted in %s" f *notedfile*))
       (t
	(write-region (format "%s\n" f) nil  *notedfile* t 0)
	)
       )
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
