(put 'myman 'rcsid 
 "$Id$")
(autoload 'man-page-mode "man-page")
(require 'dosman)

(defvar mandirs '("/usr/share/man"))

; auto compute list of man pages

(defvar manvec nil)

(defun make-manvec1 (i rmandirs)
  (let (foo)
    (loop
     for x in rmandirs
     do
     (loop
      for w in '("man" "cat")
      do
      (loop for y in (get-directory-files x t (concat w (format "%s" i)))
	    do 
	    (push y foo)
	    ))) foo))

(defun make-manvec ()
  "generate vector of directories containing man pages"
  (interactive)
  (setq manvec 
	(let ((v (make-vector 9 nil))
	      (rmandirs (reverse mandirs)) bar)
	  (loop for i from 1 to 8
		do
		(aset v i (make-manvec1 i rmandirs))
		(setq bar (append bar (aref v i)))
		)
	  (aset v 0 bar)
	  v)
	)
  )

(defun manlike (cmd &optional section short)
  (let* ((exact (and section (not (string= section "*"))))
	 (sectionp (read (if exact section "0")))
	 foo)

    (loop for dir in (aref manvec sectionp)
	  do
	  (loop 
	   for fn in (directory-files dir (not short) (concat "^" cmd))
	   if (cond
	       (exact (string-match (format "%s\.%s$" cmd (or section "*")) fn))
	       (t  (string-match "[^~]$" fn)))
	   do (push fn foo))
	  )
    (reverse foo)
    )
  )

(defun y-or-n-list (l)
  (catch 'done
    (mapcar '(lambda (x) 
	       (let ((v (y-or-n-q-p "%s " " \C-m" x)))
		 (cond 
		  ((eq v ?q) (throw 'done nil))
		  ((eq v ?\C-m) (throw 'done x)
		   )))) l)
    nil)
  )

(defun myman1 (cmd cmdbuf)
  (let ((b (zap-buffer cmdbuf)))
    (if b 
	(progn
	  (pop-to-buffer b)
	  (cd (file-name-directory cmd))
	  (insert-file-contents cmd)
	  (if (search-forward "" nil t)
	      (fix-man-page)
  ;    (progn	;fix it up.  do this once, as needed
  ;      (fix-man-page)
  ;      (write-file fn))
	    )
	  (toggle-read-only)
	  (beginning-of-buffer)
	  (man-page-mode t)
	  b)))
  )

; prefer cats to mans
(defvar pick-manpage-from-list nil)

(defun myman (cmd)
  (interactive 
   (list (read-string (format "man (%s): " (indicated-word)))))
  (let* ((cmd (if (> (length cmd) 0) cmd (indicated-word)))
	 (cmdbuf (concat "*" cmd " man*"))
	 (p1 (string-match "([0-9])" cmd))
	 (section (and p1 (prog1
			      (substring cmd (1+ (match-beginning 0)) (1- (match-end 0)))
			    (setq cmd (substring cmd 0 (match-beginning 0)))
			    )))
	 )
    (cond ((get-buffer cmdbuf)
	   (progn
	     (pop-to-buffer cmdbuf)
	     (beginning-of-buffer)))
	  ((let* ((fns (manlike cmd section)))
	     (cond ((> (length fns) 1) 
		    (myman1 (if pick-manpage-from-list
				(y-or-n-list fns)
			      (car fns))
			    cmdbuf))
		   (fns (myman1 (car fns) cmdbuf))
		   )) t)
	  ((find-any-fn cmd) t)
	  ((assoc (upcase cmd) doshelp)
	   (dos-help cmd t))
	  (t ; file no exist. try auto help
	   (let ((s
		  (condition-case x
		      (eval-process cmd "--help")
		    ('file-error      (condition-case x
					  (eval-process cmd "-?")
					('file-error nil))))))
	     (if (> (length s) 0)
		 (progn
		   (setq b (zap-buffer (concat "*" cmd " help*")))
		   (pop-to-buffer b)
		   (insert s)
		   (beginning-of-buffer))
	       (message "%s not found." cmd)))))

    ))

(defun kill-all-mans () (interactive)
  (mapcar 'kill-buffer
	  (loop for x being the buffers 
		if (eq 'man-page-mode (save-excursion (set-buffer x) major-mode))
		collect x))
  )

(or manvec (make-manvec))
