(put 'fileness 'rcsid 
 "$Id: fileness.el,v 1.5 2004-10-01 23:07:54 cvs Exp $")

(defun wordness (&optional arg)
  "treat file descriptors as words in their entirety
with optional ARG, toggles current behavior.  see `fileness'
"
  (interactive)
  (if (and arg (= (char-syntax ?/) ?w))
      (fileness)
    (progn
      (modify-syntax-entry ?/ "w" (syntax-table))
      (modify-syntax-entry ?_ "w" (syntax-table))
      (modify-syntax-entry ?- "w" (syntax-table))
      (modify-syntax-entry ?. "w" (syntax-table))
      (modify-syntax-entry ?: "w" (syntax-table))
      (modify-syntax-entry ?~ "w" (syntax-table))

      )
    )
  )

(defun fileness (&optional arg)
  "treat individual elements of file descriptors as words
with optional ARG, toggles current behavior.  see `wordness'
"
  (interactive)
  (if (and arg (= (char-syntax ?/) ?.))
      (wordness)
    (progn
      (modify-syntax-entry ?/ "." (syntax-table))
      (modify-syntax-entry ?: "." (syntax-table))
      (modify-syntax-entry ?. "." (syntax-table))

      )
    )
  )
