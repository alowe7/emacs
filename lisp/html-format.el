(put 'html-format 'rcsid 
 "$Id: html-format.el,v 1.6 2000-10-03 16:50:28 cvs Exp $")
(provide 'html-format)

(defvar *margin* 4)

(defun html-format-region (start end buffer &optional delete)
  (interactive "r")
  (let ((b (or (bufferp buffer) (get-buffer-create buffer))))
    (perl-command-region start end "fast-html-format" delete buffer nil
			 (format "-m%d" *margin*) 
			 (format "-w%d" (- (window-width) 4)))
    (pop-to-buffer b)
    (view-mode)
    (not-modified)
    )
  )

(defun html-format-file (f)
  (interactive "fFilename: ")
  (let ((b (zap-buffer (concat (file-name-sans-extension f) " *html*"))))
    (insert-file-contents f)
    (shell-command-on-region
     (point-min) (point-max)
     (concat "fast-html-format" 
	     (format " -l%d" *margin*) 
	     (format "-m%d" (- (window-width) 4)))
     b)
    (pop-to-buffer b)
    (beginning-of-buffer)
    (not-modified)
    (view-mode))
  )

(defun clean-html ()
  "extract all html elements from buffer"
  (interactive)
  (while (search-forward-regexp "<[^>]*>" nil t)
					;    (read-string (buffer-substring (match-beginning 0) (match-end 0)))
    (kill-region (match-beginning 0) (match-end 0))
    ))

(defun html-format-buffer () "" (interactive)
  (html-format-region
   (point-min) (point-max) 
   (concat (file-name-sans-extension (buffer-name)) " *html*")
   )
  )
