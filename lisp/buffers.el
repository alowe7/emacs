(put 'buffers 'rcsid 
 "$Id$")

(require 'scratch-mode)

;; walk mru list of buffers

(defun collect-buffers (mode) 
  (let ((l (loop for x being the buffers
		 if (eq mode (progn (set-buffer x) major-mode))
		 collect x)))
    (and l (append (cdr l) (list (car l))))
    )
  )


(defun collect-buffers-mode (mode)
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

(defun collect-buffers-named (pat)
  "list buffers with names matching PAT"
  (interactive "spat: ")
  (loop for x in (real-buffer-list nil)
	when (string-match pat (buffer-name x))
	collect x )
  )

(defun collect-buffers-with (pat)
"list buffers with contents matching PAT"
  (loop for x in (real-buffer-list nil)
	when (string-match pat (save-excursion (set-buffer x) (buffer-string)))
	collect x )
  )

(defun collect-buffers-with-mode (pat mode)
  "list buffers with contents matching PAT and `major-mode' matching MODE"
  (loop for x in (real-buffer-list nil)
	when (save-excursion 
	       (set-buffer x)
	       (and (eq mode major-mode)
		    (string-match pat (buffer-string)))
	       )
	collect x )
  )

(defun collect-buffers-in (pat)
  "list buffers with files matching PAT" 
  (loop for x in (real-buffer-list nil)
	when (let ((d (if (buffer-file-name x) (buffer-file-name x) (save-excursion (set-buffer x) default-directory))))
	       (and d (string-match pat d)))
	collect x )
  )

(defun collect-buffers-modified (&optional arg)
  "list buffers that are modified.  with optional ARG, restrict to only buffers with files"
  (loop for x in (real-buffer-list) when (and (buffer-modified-p x) (or (not arg) (buffer-file-name x)) ) collect x)
  )

(defun collect-buffers-not-modified (&optional arg)
  "list buffers that are not modified.  with optional ARG, restrict to only buffers with files"
  (loop for x in (real-buffer-list) when (and (not (buffer-modified-p x)) (or (not arg) (buffer-file-name x)) ) collect x)
  )

(defun collect-buffers-no-files (&optional modified)
  (loop for x being the buffers
	when (and 
	      (not (progn (set-buffer x) (buffer-file-name)))
	      (or (not modified) (buffer-modified-p x)))
	collect (buffer-name)))

(defun find-in-buffers (s &optional buffer-list)
  "find string s in any buffer.  returns a list of matching buffers"
  (loop for x being the buffers 
	if (save-excursion
	     (set-buffer x)
	     (goto-char (point-min))
	     (search-forward s nil t))
	collect x))

(defun kill-buffers-mode (mode)
  "kill all buffers in mode"
  (interactive (list (intern (completing-read "mode: "  (mapcar 'list (symbols-like "-mode$" t))))))
  (loop for x in (collect-buffers-mode mode)
	do
	(kill-buffer x))
  )

(defun kill-buffers-not-modified ()
  "kill all buffers in mode"
  (interactive)
  (and (y-or-n-p "kill-buffers-not-modified.  are you sure? ")
       (loop for x in (collect-buffers-not-modified)
	     do
	     (kill-buffer x)))
  )

(defun  bury-buffer-1 () (interactive) 
  (unless (member last-command '(unbury-buffer bury-buffer-1))
    (setq *collect-buffers-vector* (apply 'vector (real-buffer-list))
	  *collect-buffers-vector-length* (length *collect-buffers-vector*)
	  *collect-buffers-vector-index* -1))
  (let ((next (% (1+ *collect-buffers-vector-index*) (length *collect-buffers-vector*))))
    (switch-to-buffer (aref *collect-buffers-vector* next))
    (setq *collect-buffers-vector-index* next)
    )
  )

(defun unbury-buffer () (interactive) 
  (unless (member last-command '(unbury-buffer bury-buffer-1))
    (setq *collect-buffers-vector* (apply 'vector (real-buffer-list))
	  *collect-buffers-vector-length* (length *collect-buffers-vector*)
	  *collect-buffers-vector-index* 1))
;; note requires %% symmetrical around 0
  (let ((next (abs (%% (1- *collect-buffers-vector-index*) (length *collect-buffers-vector*)))))
    (switch-to-buffer (aref *collect-buffers-vector* next))
    (setq *collect-buffers-vector-index* next)
    )
  )

(provide 'buffers)