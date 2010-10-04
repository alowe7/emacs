(put 'xzupdate 'rcsid 
 "$Id$")

(defun xz-update (&optional update l)
  "produces a list of modules in (xz-db) newer than database.
 with optional arg UPDATE, updates the files in the database, 
 and saves the database"
  (interactive "P")
  ; doesn't find entirely new files

  (let (*xz-show-lines* 
	(ood (or l
		 (let* ((x (xz-issue-query ".M"))
			(dbtime (elt (file-attributes (xz-db)) 5)))
				 
  ; collect a list of files newer than the database
		   (loop for y in x 
			 when (< (compare-filetime dbtime (elt (file-attributes (car y)) 5)) 0)
			 collect (car y))))))
    (if update 
	(progn
	  (loop for y in ood do
		(xz-issue-query (concat ".-" y))
		(xz-issue-query (concat ".+" y)))
	  (xz-issue-query ".s")))
    ood)
  )


;(setq zzz (xz-update))
;(format-time-string "%c" (elt (car zzz) 5))

(defun xz-updatep () (interactive)
  (let ((f (xz-update)))
    (if f (let ((b (zap-buffer "*xz files*")))
	    (save-window-excursion
	      (insert "buffers out of date with database:\n\n")
	      (loop for x in f do (insert x "\n"))
	      (fill-region (point-min) (point-max))
	      (pop-to-buffer b)
	      (beginning-of-buffer)
	      (if (y-or-n-p "update? ") 
		  (xz-update t f)
		))))))

(xz-updatep)

