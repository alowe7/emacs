(put 'cygwin 'rcsid
 "$Id$")

(require 'long-comment)

; lazy load 
(defvar *cygwin-init* nil)

(defun cygwin-init ()
  (setq *cygwin-init* t)

  ; initialize mount table
  (defvar *cygdrive-prefix*  (car
			      (split
			       (cadr (split (eval-process "mount -p") "
"))
			       )
			      )
    "prefix for cygwin mounts"
    )

  (defvar *cygmounts*
    (remove-if (function (lambda (x) (not (string-match (concat "^" *cygdrive-prefix*)  (car x)))))
	       (loop for x in (split (eval-process "mount") "
")
		     collect 
		     (let ((l (split x " ")))
		       (list (caddr l) (car l))))
	       )
    "list of mounted file systems"
    )
  )

(defun mount-hook (f)
  "apply mounts to FILE if applicable"

  (unless *cygwin-init* (cygwin-init))

  (cond ((absolute-path f)
	 (check-unc-path f))
	(t
	 (let ((e (if (absolute-path default-directory)
		      (concat (cadr (assoc "/" *cygmounts*)) f)
		    (loop for y in *cygmounts*
			  if (or
			      (string-match (concat "^" (car y) "/") f)
			      (string-match (concat "^" (car y) "$") f))
			  return (replace-regexp-in-string (concat "^" (car y)) (cadr y) f)
			  ))))
	   (and e (mount-orig-expand-file-name e))
	   )
	 f
	 )
	)
  )



(defun cygwin-find-file-hook ()
  "automatically follow symlink unless prefix is given"
  (if (string-match "^!<symlink>" (buffer-string))
      (find-file (substring (buffer-string) (match-end 0))))
  )

;; add this to host-init:
; (add-hook 'find-file-hooks 'cygwin-find-file-hook)


;; advise expand-file-name to be aware of *cygmounts*

;; (defadvice expand-file-name (around expand-file-name-hook activate)
;;   (let* ((d (ad-get-arg 0))
;; 	 (d1 (unless (string-match "^//\\|^~\\|^[a-zA-`]:" d)
;; 	       (loop for y in *cygmounts* 
;; 		     if (or
;; 			 (string-match (concat "^" (car y) "/") d)
;; 			 (string-match (concat "^" (car y) "$") d))
;; 		     return (replace-regexp-in-string (concat "^" (car y)) (cadr y) d)
;; 		     ))))
;;     (if d1 (ad-set-arg 0 d1))
;; 
;;     ad-do-it
;;     )
;; )


; (if (ad-is-advised 'expand-file-name) (ad-unadvise 'expand-file-name))
; (expand-file-name (fw "broadjump"))

;; another way to do this:

(defun cygwin-canonify-mount (fn)
  (unless *cygwin-init* (cygwin-init))
  (let* ((fn (canonify fn 0))
	 (real-fn
	  (loop for y in *cygmounts* when
		(string-match (car y) fn)
		return 
		(concat (cadr y) (substring fn (match-end 0))))))
    real-fn
    )
  )

(defun cygwin-file-not-found ()
  "automatically follow symlink unless prefix is given"
  (let ((real-fn (cygwin-canonify-mount (buffer-file-name))))
    (if (and real-fn (file-exists-p real-fn)) (find-file real-fn))
    )
  )

;; add this to host-init:
; (add-hook 'find-file-not-found-functions 'cygwin-file-not-found)

(defadvice fb-indicated-file (around fb-indicated-file-hook activate)
  ad-do-it

  (let ((f ad-return-value))

    (cond
     ((and f (file-exists-p f)) f)
     (t
      (setq f (cygwin-canonify-mount f))
      (if (and f (file-exists-p f)) (setq ad-return-value f))
      ))
    )
  )

; (if (ad-is-advised 'fb-indicated-file) (ad-unadvise 'fb-indicated-file))




(provide 'cygwin)
