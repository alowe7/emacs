(put 'eval-utils 'rcsid
 "$Id: eval-utils.el,v 1.2 2003-04-15 16:32:15 cvs Exp $")
(provide 'eval-utils)
(require 'cat-utils)

(require 'zap)

;; file and directory handling utilities

(defun read-file (f &optional all)
  "returns contents of FILE as a string" 
  (and f (file-exists-p f)
       (save-window-excursion
	 (let ((b (zap-buffer " *tmp*")) s)
	   (insert-file-contents f)
	   (setq s (buffer-string))
	   (kill-buffer b)
	   (if all s (chomp s)))
	 )
       )
  )

; directory-files appears to have a bug matching arbitrary regexps.
(defun get-directory-files (&optional directory full match)
  "return directory contents as a list of strings, excluding . and .."
  (interactive "sName: ")

  (loop for x in 
	(directory-files (or directory ".") full match)
	when 
	(let ((z (file-name-nondirectory x)))
	  (not (or (string= z ".") (string= z ".."))))
	collect x)
  )

(defun get-subdirs (dir)
  "list subdirectories of DIR"
  (loop for x in (get-directory-files dir t)
	when (-d x) collect x)
  )

(defvar backup-file-extension ".bak")
(defun backup-file (fn)
  " save prior version of FILE if any"

  (and fn (file-exists-p fn)
       (rename-file fn (concat fn backup-file-extension) t))
  )
