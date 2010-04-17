;; maybe it would be better to comb the registry.
(cond ((string-match "1.3.2" (eval-process "uname" "-r"))

       ;; mount output format for (beta) release 1.3.2
       (defun cygmounts ()
	 " list of cygwin mounts"
	 (setq cygmounts
	       (loop for x in (split (eval-process "mount") "
")
		     collect 
		     (let ((l (split x " ")))
		       (list (caddr l) (car l))))
	       )
	 )
       )
      ((string-match "1.5" (eval-process "uname" "-r"))
;;  this was originally intended to catch interminable timeouts on disconnected drives
       (defun cygmounts () (setq cygmounts nil))
       )
      (t 
       ;; mount output format for release 1.0
       (defun cygmounts ()
	 " list of cygwin mounts"
	 (setq cygmounts
	       (loop for x in (cdr (split (eval-process "mount") "
"))
		     collect
		     (let
			 ((l (split (replace-regexp-in-string "[ ]+" " " x))))
		       (list (cadr l) (car l))))
	       )
	 )
       )
      )


; initialize mount table
(cygmounts)


(defun mount-hook (f)
  "apply mounts to FILE if applicable"
  (cond ((absolute-path f)
	 (check-unc-path f))
	(t
	 (let ((e (if (absolute-path default-directory)
		      (concat (cadr (assoc "/" cygmounts)) f)
		    (loop for y in cygmounts
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
(defun mount-hook-file-commands ()
  (mount-unhook-file-commands)
  (loop for x in mount-hook-file-commands do
	(let ((hook-name (intern (concat "hook-" (symbol-name x)))))
	  (eval `(defadvice ,x (around ,hook-name first activate) 
		   (ad-set-arg 0 (mount-hook (ad-get-arg 0)))
		   ad-do-it
		   )
		)
	  )
	)
  )

; this is best done in host-init
; (mount-hook-file-commands)

(defun cygwin-find-file-hook ()
  "automatically follow symlink unless prefix is given"
  (if (string-match "^!<symlink>" (buffer-string))
      (find-file (substring (buffer-string) (match-end 0))))
  )

(add-hook 'find-file-hooks 'cygwin-find-file-hook)

;; advise expand-file-name to be aware of cygmounts

;; (defadvice expand-file-name (around expand-file-name-hook activate)
;;   (let* ((d (ad-get-arg 0))
;; 	 (d1 (unless (string-match "^//\\|^~\\|^[a-zA-`]:" d)
;; 	       (loop for y in cygmounts 
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
