(put 'post-vc 'rcsid
 "$Id: post-vc.el,v 1.5 2001-10-25 22:27:20 cvs Exp $")

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

(require 'advice)

(defadvice vc-diff (after 
		    hook-vc-diff
		    first activate)
  ""

  (turn-on-lazy-lock)
  (setq tab-width 4)
  (recenter)
  )

; (ad-is-advised 'vc-diff)
; (ad-unadvise 'vc-diff)
