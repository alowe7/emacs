(put 'post-vc 'rcsid
 "$Id: post-vc.el,v 1.4 2001-08-28 22:11:39 cvs Exp $")

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

(defun rcsid (arg) (interactive "P")
  (let* ((f (if arg (read-file-name "file: ") (buffer-file-name)))
	 (id (get (intern (file-name-sans-extension (file-name-nondirectory f))) (quote rcsid))))
    (message (or id "no rcsid"))
    )
  )
