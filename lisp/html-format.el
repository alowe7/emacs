(put 'html-format 'rcsid 
 "$Id: html-format.el,v 1.8 2004-09-03 15:12:33 cvs Exp $")
(provide 'html-format)

(defvar *margin* 4)

(defun html-format-region (start end buffer &optional delete)
  (interactive "r")
  (let ((b (or (and (bufferp buffer) buffer) (get-buffer-create buffer))))
    (perl-command-region start end "fast-html-format" delete buffer nil
			 (format "-m%d" *margin*) 
			 (format "-w%d" (- (window-width) 4)))
    (pop-to-buffer b)
    (beginning-of-buffer)
    (view-mode)
    (set-buffer-modified-p nil)
    )
  )

(defun html-format-file (f)
  (interactive "fFilename: ")
  (debug)
  (let ((b (zap-buffer (concat (file-name-sans-extension f) " *html*"))))
    (insert-file-contents f)
    (perl-command-region (point-min) (point-max) "fast-html-format" t b nil
			 (format " -l%d" *margin*) 
			 (format "-m%d" (- (window-width) 4)))
    (pop-to-buffer b)
    (beginning-of-buffer)
    (set-buffer-modified-p nil)
    (view-mode))
  )

(defun html-format-buffer ()
  "" 
  (interactive)

  (html-format-region
   (point-min) (point-max) 
   (zap-buffer-0 (concat (file-name-sans-extension (buffer-name)) " *html*"))
    )
  )

(defun clean-html ()
  "extract all html elements from buffer"
  (interactive)
  (while (search-forward-regexp "<[^>]*>" nil t)
					;    (read-string (buffer-substring (match-beginning 0) (match-end 0)))
    (kill-region (match-beginning 0) (match-end 0))
    ))
