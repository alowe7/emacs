(put 'post-locate 'rcsid 
 "$Id: post-locate.el,v 1.9 2007-06-16 01:21:36 noah Exp $")

(require 'fb)

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

