(put 'glimpse2 'rcsid 
 "$Id: glimpse2.el,v 1.4 2000-10-03 16:50:28 cvs Exp $")
(require 'compile)

(defvar glimpse-mode-map nil)

(defun glimpse-goto-hit (&optional arg)
  (interactive "P")
  (let* ((l (aref *glimpsevec* (count-lines (point-min) (point))))
	 (fn (car l))
	 (ln (car (read-from-string (cdr l))))
	 (b (find-file-noselect fn)))
    (if arg (pop-to-buffer b)
      (switch-to-buffer b))
    (goto-line ln)
    )
  )
(defun glimpse-goto-hit-other-window ()
  (interactive)
  (glimpse-goto-hit t)
  )
(defun glimpse-hit-info ()
  (interactive)
  (let* ((l (aref *glimpsevec* (count-lines (point-min) (point))))
	 (fn (car l))
	 (ln (car (read-from-string (cdr l)))))
	 (message "%s:%d" fn ln)
    )
  )


(defun glimpse-mode ()
  (interactive)
  (use-local-map
   (or  glimpse-mode-map
	(prog1
	    (setq glimpse-mode-map
		  (copy-keymap compilation-mode-map))
	  (define-key glimpse-mode-map "\C-m" 'glimpse-goto-hit)
	  (define-key glimpse-mode-map "o" 'glimpse-goto-hit-other-window)
	  (define-key glimpse-mode-map "?" 'glimpse-hit-info)
	  ))
   )
  )

;; todo -- merge lists of hitvecs
(defun glimpse1 (pat)
  (let ((wb (zap-buffer " __glimpse__")))
    (loop for x in 
	  (split 
	   (progn
	     (call-process "glimpse" nil wb nil "-n" pat)
	     (set-buffer wb)
	     (buffer-string)) "
")
	  unless (< (length x) 1)
	  collect 
	  (split x ":")
	  )
    )
  )
; (glimpse1 "master browser")

(defun glimpse (pat)
  (interactive "sPat: ")
  (let* ((l (glimpse1 pat))
	 (b (zap-buffer "*glimpse*"))
	 (vec
	  (apply 'vector 
		 (loop for p in l
		       collect
		       (progn
			 (insert (caddr p) "\n")
			 (cons (car p) (cadr p)))
		       ))))
    (setq *glimpsevec* vec)
    (make-variable-buffer-local '*glimpsevec*)
    (pop-to-buffer b)
    (beginning-of-buffer)
    (glimpse-mode)
    (wrap)
    (not-modified)
    (setq buffer-read-only t)
    (setq mode-line-buffer-identification pat)
    )
  )