(put 'post-info 'rcsid
 "$Id$")

(defvar *info-files*
  (apply 'nconc 
	 (mapcar
	  (function (lambda (d)
		      (mapcar
		       (function (lambda (x)
				   (replace-regexp-in-string "\.info\\(\.gz\\)*$" "" x)))
		       (remove* "info-[0-9]+"
				(get-directory-files d nil "\.info")
				:test (function (lambda (x y) (string-match x y))))
		       )))

	  (nconc Info-default-directory-list Info-additional-directory-list)
	  )
	 )
  )
(defvar *last-info-file* "")
(defvar *last-info-thing* "")

(defun maninfo (thing)
  "jump to an info page for THING
thing may be of the format (FILE)thing
in this case thing is optional, and if not specified, you go to the main menu for file.
"
  (interactive (list
		(read-string* "info for (%s): " (format "(%s)%s" *last-info-file* *last-info-thing*))
		))

  (cond
   ((string-match "^\(.*\)" thing)
    (let ((last-info-file (substring thing (1+ (match-beginning 0)) (1- (match-end 0))))
	  (last-info-thing (substring thing (match-end 0))))
      (info thing)
      ; need this gyration to preserve match-beginning and match-end, and also to avoid setting defaults if there was an error
      (setq *last-info-file* last-info-file)
      (setq *last-info-thing* last-info-thing)
      )
    )
   (t
    (let ((info-file
	   (or info-file
	       (and (called-interactively-p 'any)
		    (completing-read* "in (%s): "  *info-files* *last-info-file* '(nil t)))
	       *last-info-file*
	       (error "info-file is required unless called interactively or specified as part of thing"))))

      (info (format "(%s)%s" info-file thing))
      (setq *last-info-file* info-file)
      (setq *last-info-thing* thing)
      ))
   )
  )

(define-key help-map "\C-i" 'maninfo)
