(put 'worlds 'rcsid
 "$Id: worlds.el,v 1.1 2004-01-30 17:05:45 cvs Exp $")

(chain-parent-file t)

(setq *sh-custom-parser* 'my-sh-extension)

(defun world-parser (cmd &rest args)
  (if sh-debug
      (read-string (format "don't know what to do with %s" cmd))
    )
  )