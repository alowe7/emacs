(put 'pdf-view 'rcsid 
 "$Id$")

(defvar *pdf-to-text-program* "c:/Program Files/PTCONVERTER/ptconverter.exe")

(defun pdf-view (&optional file)
  "Run `*pdf-to-text-program*' on indicated FILE.
view results in a temp buffer
"
  (interactive (list (read-file-name* "Convert PDF to text (%s): " (cond ((eq major-mode 'dired-mode) (dired-get-filename)) (t (expand-file-name (indicated-filename)))))))

  (let ((goober (w32-canonify file))
	(b (zap-buffer (format "%s *text*" (file-name-nondirectory file)))))
    (call-process *pdf-to-text-program* goober b)
    (switch-to-buffer b)
    (goto-char (point-min))
    (set-buffer-modified-p nil)
    (view-mode)
    )
  )

; tbd additional cleanup
; (query-replace " " " " nil (if (and transient-mark-mode mark-active) (region-beginning)) (if (and transient-mark-mode mark-active) (region-end)))

(add-file-association "pdf" 'pdf-view)

(provide 'pdf-view)
