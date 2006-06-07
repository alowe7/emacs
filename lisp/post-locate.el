(put 'post-locate 'rcsid 
 "$Id: post-locate.el,v 1.5 2006-06-07 21:36:10 alowe Exp $")

(require 'fb)

(setq locate-mode-map fb-mode-map)

;; todo -- add qsave history
(defadvice locate-mode (around 
			hook-locate-mode
			last
			activate)
  ""

  ad-do-it

  (set-syntax-table fb-mode-syntax-table)
  )

; (if (ad-is-advised 'locate-mode) (ad-unadvise 'locate-mode))

(defadvice locate (around 
		   hook-locate
		   last
		   activate)
  ""

  ad-do-it

  (qsave-search (current-buffer) (ad-get-arg 0) default-directory)
  )

; (if (ad-is-advised 'locate) (ad-unadvise 'locate))


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
