(put 'buffers 'rcsid 
 "$Id: buffers.el,v 1.4 2001-04-27 11:37:59 cvs Exp $")

;; walk mru list of buffers

(defun collect-buffers (mode) 
  (let ((l (loop for x being the buffers
		 if (eq mode (progn (set-buffer x) major-mode))
		 collect x)))
    (and l (append (cdr l) (list (car l))))
    )
  )


(defun list-buffers-mode (mode)
  (interactive "Smode: ")
  "returns a list of buffers with specified MODE
when called interactively, displays a pretty list"
  (let ((l 
	 (loop
	  for x being the buffers 
	  if (eq (progn (set-buffer x) major-mode) mode) 
	  collect x)))
    (if (interactive-p) 
	(let ((b (zap-buffer "*Buffer List*")))
	  (set-buffer b)
	  (dolist (x l) (insert (buffer-name x) "\n"))
	  (pop-to-buffer b))
      l)))

(defun list-buffers-named (pat)
  "list buffers with names matching PAT"
  (interactive "spat: ")
  (loop for x in (get-real-buffer-list nil)
	when (string-match pat (buffer-name x))
	collect x )
  )


(defun list-buffers-with (pat)
  (loop for x in (get-real-buffer-list nil)
	when (string-match pat (save-excursion (set-buffer x) (buffer-string)))
	collect x )
  )

(defun find-in-buffers (s &optional buffer-list)
  "find string s in any buffer.  returns a list of matching buffers"
  (loop for x being the buffers 
	if (save-excursion
	     (set-buffer x)
	     (goto-char (point-min))
	     (search-forward s nil t))
	collect x))

(provide 'buffers)