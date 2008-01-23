(put 'post-locate 'rcsid 
 "$Id: post-locate.el,v 1.10 2008-01-23 05:51:11 alowe Exp $")

(require 'fb)
(require 'qsave)

(setq locate-mode-map fb-mode-map)

(defadvice locate-mode (around 
			hook-locate-mode
			last
			activate)
  ""

  ad-do-it

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


(defun buffer-string-no-properties() 
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
