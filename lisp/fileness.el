(put 'fileness 'rcsid 
 "$Id: fileness.el,v 1.4 2001-08-28 22:11:39 cvs Exp $")

(defun wordness ()
  (interactive)
  (modify-syntax-entry ?/ "w" (syntax-table))
  (modify-syntax-entry ?_ "w" (syntax-table))
  (modify-syntax-entry ?- "w" (syntax-table))
  (modify-syntax-entry ?. "w" (syntax-table))
  (modify-syntax-entry ?: "w" (syntax-table))
  (modify-syntax-entry ?~ "w" (syntax-table))
  )

(defun fileness ()
  (interactive)
  (modify-syntax-entry ?/ "." (syntax-table))
  (modify-syntax-entry ?: "." (syntax-table))
  (modify-syntax-entry ?. "." (syntax-table))
  (message "fileness")
  )
