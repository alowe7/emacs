(put 'post-vc 'rcsid
 "$Id: post-vc.el,v 1.3 2001-07-18 22:18:18 cvs Exp $")

(defun identify () 
  "insert a sccs ID string at head of file."
  (interactive)
  (let ((id (intern (file-name-sans-extension (file-name-nondirectory (buffer-file-name))))))
    (goto-char (point-min))
;; quote dollars to avoid keyword expansion here
    (insert (format "(put '%s 'rcsid\n \"\$Id\$\")\n" id)))
  )

;; fixup crlf eol encoding
(add-hook 'vc-checkin-hook '(lambda () (find-file-force-refresh)))

(defun rcsid () (interactive)
  (let ((id (get (intern (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))) (quote rcsid))))
    (message (or id "no rcsid"))
    )
  )
