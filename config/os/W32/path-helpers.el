(defvar *path-sep* ";")

(defun add-to-path (dir &optional prepend)
  (unless (member dir (split (getenv "PATH") *path-sep*))
    (setenv "PATH" 
	    (concat (getenv "PATH") *path-sep* dir)
	    ))
  )
