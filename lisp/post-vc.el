(put 'post-vc 'rcsid
 "$Id: post-vc.el,v 1.1 2000-10-12 17:32:17 cvs Exp $")

(defun identify () 
  "insert a sccs ID string at head of file."
  (interactive)
  (let ((id (intern (file-name-sans-extension (file-name-nondirectory (buffer-file-name))))))
    (goto-char (point-min))
    (insert (format "(put '%s 'rcsid\n \"$Id: post-vc.el,v 1.1 2000-10-12 17:32:17 cvs Exp $\")\n" id)))
  )

