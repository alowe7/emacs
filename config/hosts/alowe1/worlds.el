(put 'worlds 'rcsid
 "$Id$")

(chain-parent-file t)

(setq *sh-custom-parser* 'my-sh-extension)

(defun world-parser (cmd &rest args)
  (if sh-debug
      (read-string (format "don't know what to do with %s" cmd))
    )
  )

(setq *tw-default-class* "l")
(setq *tw-default-state* "active")
; (la :class "all" :state "all")
