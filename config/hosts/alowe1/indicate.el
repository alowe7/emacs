(put 'indicate 'rcsid
 "$Id: indicate.el,v 1.1 2004-12-10 18:15:17 cvs Exp $")

; this module overrides some functions defined in indicate.el
; todo: promote this implementation

(chain-parent-file t)

;; this may be too round-about, but the original implementation set off an undebuggable time-bomb 

(defun indicated-word (&optional include-chars from to exclude-chars)
  "evaluates to word indicated by cursor
   if string  INCLUDE-CHARS is specified, 
temporarily change the syntax entry for each char in the string to \"w\"
in the current buffer
" 
  (interactive)

  (let* ((old-table (syntax-table))
	(new-table (copy-syntax-table old-table))
	w)

    (save-restriction 
      (narrow-to-region (or from (point-min)) (or to (point-max)))

      (set-syntax-table new-table)

      (loop for char across include-chars do
      	    (modify-syntax-entry char "w"))
      (loop for char across exclude-chars do
      	    (modify-syntax-entry char "."))

      (setq *indicated-word-region* (bounds-of-thing-at-point 'word)
	    w (if *indicated-word-region*
		  (buffer-substring (car *indicated-word-region*) (cdr *indicated-word-region*))
		""))

      (set-syntax-table old-table)

      (if (interactive-p) (message w) w)
      )
    )
  )


(defun indicated (&optional thing include-chars exclude-chars from to)
  "evaluates to THING indicated by cursor
see `bounds-of-thing-at-point' for possible values of thing.
   if string  INCLUDE-CHARS is specified, 
temporarily change the syntax entry for each char in the string to \"w\"
see `modify-syntax-entry' for possible values for that.
in the current buffer
" 
  (interactive)

  (let* (
	 (thing (or thing 'symbol))
	 (old-table (syntax-table))
	 (new-table (copy-syntax-table old-table))
	 (include-syntax-char (cond ((eq thing 'symbol) "_")
				    (t "w")))
	 (exclude-syntax-char ".")
	 w)

    (save-restriction 
      (narrow-to-region (or from (point-min)) (or to (point-max)))

      (set-syntax-table new-table)

      (loop for char across include-chars do
      	    (modify-syntax-entry char include-syntax-char))
      (loop for char across exclude-chars do
      	    (modify-syntax-entry char exclude-syntax-char))

      (setq *indicated-word-region* (bounds-of-thing-at-point thing)
	    w (if *indicated-word-region*
		  (buffer-substring (car *indicated-word-region*) (cdr *indicated-word-region*))
		""))

      (set-syntax-table old-table)

      (if (interactive-p) (message w) w)
      )
    )
  )
