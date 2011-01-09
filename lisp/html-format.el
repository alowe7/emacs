(put 'html-format 'rcsid 
 "$Id$")
(provide 'html-format)

(defvar *margin* 4)
(defvar *w3m* (let ((f (or (and (boundp 'w3m-command) w3m-command) (whence "w3m"))))
		(and (file-executable-p f ) f)) "location of w3m command if available or nil")

(defun html-format-region (start end buffer &optional delete)
  (interactive "r")
  (let ((b (or (and (bufferp buffer) buffer) (get-buffer-create buffer))))
    (perl-command-region start end "fast-html-format" delete buffer nil
			 (format "-m%d" *margin*) 
			 (format "-w%d" (- (window-width) 4)))
    (pop-to-buffer b)
    (goto-char (point-min))
    (view-mode)
    (set-buffer-modified-p nil)
    )
  )

(defun html-format-file (f)
  "return contents of FILE formatted as html"
  (interactive "fFilename: ")
  ; w3m is preferred.  if not found, use HTML::FormatText

  (if *w3m*
      (eval-process *w3m* f)
    (perl-command "fast-html-format" f))
  )

(defun html-format-buffer ()
  "" 
  (interactive)

  ; if buffer is not modified and associated with a file, use that
  (if (and (not (buffer-modified-p)) (file-exists-p (buffer-file-name)))
      (html-format-file (buffer-file-name))
  ; otherwise use HTML::FormatText
    (html-format-region
     (point-min) (point-max) 
     (zap-buffer-0 (concat (file-name-sans-extension (buffer-name)) " *html*"))
     )
    )
  )

(defun clean-html ()
  "extract all html elements from buffer"
  (interactive)
  (while (search-forward-regexp "<[^>]*>" nil t)
					;    (read-string (buffer-substring (match-beginning 0) (match-end 0)))
    (kill-region (match-beginning 0) (match-end 0))
    ))
