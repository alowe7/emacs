(put 'post-locate 'rcsid 
 "$Id: post-locate.el,v 1.2 2002-12-02 03:14:22 cvs Exp $")

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

  (run-hooks 'after-find-file-hook)

  )

; (if (ad-is-advised 'locate) (ad-unadvise 'locate))

