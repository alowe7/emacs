(put 'lwhence 'rcsid 
 "$Id: lwhence.el,v 1.6 2001-02-09 14:29:51 cvs Exp $")
(require 'indicate)
(provide 'lwhence)

(defun fwhence (fn) 
  "find function F along load-path"
  (interactive "aFunction: ")
  (or (and (boundp 'autoload-alist)
	   (cadr (assoc fn autoload-alist)))
      (let* ((s (documentation fn))
	     (f (and (string* s)
		     (substring s (1+ (string-match "`" s))
				(string-match "'" s)))))
	(loop
	 for x in load-path by 'cdr
	 do
	 (if (file-exists-p (concat x "/" f ".el")) 
	     (return (concat x "/" f ".el")))))
      )
  )
; (fwhence 'lpr-buffer)

(defun whence-lib (library) 
  "finds LIBRARY along load-path"
  (interactive "sLibrary: ")
  (let* ((l (if
	       (file-name-extension library)
	       '(lambda (f) (-f (concat x "/" library)))
	     '(lambda (f) (-f (concat x "/" library ".el")))))
	 (v (loop for x in load-path thereis (funcall l x))))
    (if (interactive-p) (message "%s" v) v)
    )
  )
;; (whence-lib "os-init")

(defun find-whence-lib (l)
 (interactive "sLibrary: ")
 (find-file (whence-lib l)))

(fset 'find-module 'find-whence-lib)
(fset 'fm 'find-whence-lib)


(defun lwhence (thing) 
  "returns library containing thing"
  (interactive 
   (list (complete-indicated-word "Function (%s): " obarray)))


  (catch 'done
    (let* ((fn (cond ((stringp thing) (intern thing))
		     ((symbolp thing) thing)
		     (t (throw 'done (format "don't know what to do with %s" thing)))))
	   (b (or (loop for x in load-history
			when (member fn x)
			return (car x))
		  (throw 'done (format "%s not loaded" fn))))
	   (f (loop for x in load-path
		    thereis (or (-a (format "%s/%s" x b))
				(-a (format "%s/%s.el" x b)))))
	   )

      (if (interactive-p)
	  (progn
	    (find-file f)
	    (search-forward thing))
	f)
      )
    )
  )

(define-key help-map "." 'lwhence)

(defun lcollect (fn) 
  "returns library containing fn"

  (interactive "aFunction: ")

  (let* ((b (loop for x in load-history
		  when (member fn x)
		  return (car x)))
	 (l	(loop
		 for x in load-path by 'cdr
		 when (file-exists-p (format "%s/%s.el" x b))
		 collect x
		 )))
    (if (file-exists-p b) (push b l))
    l
    )
  )

; (find-file (lwhence 'compile))
; (lcollect 'compile)

