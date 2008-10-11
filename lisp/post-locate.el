(put 'post-locate 'rcsid 
 "$Id: post-locate.el,v 1.12 2008-10-11 17:14:01 alowe Exp $")

(require 'fb)
(require 'qsave)

(setq locate-mode-map fb-mode-map)

(defun ad-remove-advice* (function class name)
  (when (ad-find-advice function class name) (ad-remove-advice function class name))
  )

; (ad-find-advice 'locate-mode 'around 'hook-locate-mode)
(ad-remove-advice*  'locate-mode 'around 'hook-locate-mode)

(defadvice locate-mode (around 
			hook-locate-mode
			last
			activate)
  ""

  ad-do-it

  (setq default-directory (expand-file-name default-directory))
  (set-syntax-table fb-mode-syntax-table)
  )

; (if (ad-is-advised 'locate-mode) (ad-unadvise 'locate-mode))

; generally, this is useful only in certain modes...

(defadvice locate-word-at-point (around 
				 hook-locate-word-at-point
				 first activate)
  ""

  (and (memq major-mode '(dired-mode shell-mode cmd-mode))
       ad-do-it
       )
  )

; (if (ad-is-advised 'locate-word-at-point) (ad-unadvise 'locate-word-at-point))


(defun buffer-string-no-properties () 
  (buffer-substring-no-properties (point-min) (point-max))
  )

(defun locate-with-filter-1 (search-string filter)
  "run `locate-with-filter' and return results as a list
"
  (interactive "ssearch-string: \nsfilter: ")

  (condition-case err
      (save-window-excursion
	(cons
	 (with-output-to-string
	   (locate-with-filter search-string filter))
	 (mapcar 'trim (nthcdr 2 (split (buffer-string-no-properties) "\n"))))
	)
    (error nil)
    )
  )

; (setq x (locate-with-filter-1 "ant" "docs/manual/toc.html"))


(defadvice locate (around 
			hook-locate
			last
			activate)
  ""

  ad-do-it

  (let ((search-string (ad-get-arg 0)))

    ad-do-it

    (qsave-search (current-buffer) search-string default-directory)
    )

  )
; (if (ad-is-advised 'locate) (ad-unadvise 'locate))


(defun locate-in (search-string &optional filter)
  (interactive "slocate files like: \nsunder directory like:")
  (locate search-string (concat "^" filter))
  )
; (locate-in "Makefile" "/x")

(require 'ctl-slash)
(define-key ctl-/-map "\C-e" 'locate-in)

(defvar locate-result-stack nil "list of locate result sets")

(defun post-locate-push-filelist ()
  (interactive)
  (let ((b (get-buffer locate-buffer-name)))
    (when (buffer-live-p b)
      (set-buffer b)
      (let ((s (buffer-string-no-properties)))
	(when (string-match "^Matches for .*

" s)
	  (let* ((filelist (substring s (match-end 0)))
		 (files (mapcar 'trim-white-space (split filelist "\n"))))
	    (add-to-list 'locate-result-stack files)
	    )
	  )
	)
      )
    )
  )

(when (ad-find-advice 'locate 'after 'locate-push-result-set) (ad-remove-advice  'locate 'after 'locate-push-result-set))

(defadvice locate (after 
		   locate-push-result-set
		   last
		   activate)
  ""

  (post-locate-push-filelist)
  )
; (if (ad-is-advised 'locate) (ad-unadvise 'locate))

; (ad-find-advice 'locate 'after 'notthere)

(defun grep-in-locate-result (pat)
  (interactive (list (read-string* "grep in last locate result set for (%s): " (thing-at-point 'word))))
  (when locate-result-stack
    (let ((filelist (car locate-result-stack)))
      (grep (concat "grep -n -i -e " pat " " (join filelist " ")))
      )
    )
  )
(define-key ctl-/-map "\C-s" ' grep-in-locate-result)
