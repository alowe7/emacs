(put 'post-vc 'rcsid
 "$Id: post-vc.el,v 1.2 2000-10-12 17:33:46 cvs Exp $")

(defun identify () 
  "insert a sccs ID string at head of file."
  (interactive)
  (let ((id (intern (file-name-sans-extension (file-name-nondirectory (buffer-file-name))))))
    (goto-char (point-min))
;; quote dollars to avoid keyword expansion here
    (insert (format "(put '%s 'rcsid\n \"\$Id\$\")\n" id)))
  )

