(put 'myblog 'rcsid
 "$Id: myblog.el,v 1.2 2006-03-17 19:34:04 alowe Exp $")

;; myblog

(require 'locations)

;; this stuff should be in db, presentation layer should do all formatting.

(defvar *blog-home-url* "http://localhost:10080/dcgs")
(defvar *blog-home* (expand-file-name "dscm" my-documents))

(defvar *areas* '((".net") ("biz") ("crypto") ("dcgs") ("j2ee") ("personal") ("tech") ("pub")))
(defvar *default-area* "pub")

(defvar *myblog-db* (expand-file-name "~/.dscm"))

(defun persist-myblog-state ()
  (write-region (format "%s\n" *default-area*) nil *myblog-db*)
  )

(defun restore-myblog-state ()
  (let ((s (read-file *myblog-db*)))
    (and (string* s) (setq *default-area* s))
    )
  )

(restore-myblog-state)

(add-hook 'kill-emacs-hook 'persist-myblog-state)

(defun get-scratch-buffer-contents (name)
  (interactive "sname: ")
  (save-window-excursion
    (let ((b (get-buffer-create name)))
      (switch-to-buffer b)
      (local-set-key "" '(lambda () (interactive) (throw 'done (buffer-string))))
;      (message
;       "C-x C-s to save C-c C-c to cancel")
; xxx too easy to lose this.. todo: use mechanism similar to xaj
      (prog1 (catch 'done
	       (recursive-edit)
	       )
	(kill-buffer b)
	)
      )
    )
  )

(defun generate-dscm-entry-name (area) (interactive)
  (format  "%s/%s/%s"  *blog-home* area (format-time-string "%y%m%d%H%M%S"))
  )

;; tbd: encode entities in content.  e.g. "&" -> "&amp;"

(defun myblog () (interactive)
  (let* (
	 (area (setq *default-area* (completing-read (format "area (%s): " *default-area*) *areas* nil t nil nil *default-area*)))
	 (subject (read-string "subject: "))
	 (timestring (format-time-string "%y%m%d %H:%M:%S"))
	 (file (generate-dscm-entry-name area))
	 (body (get-scratch-buffer-contents "*blog*"))
	 (content
	  (format "
<blog>

<date>
%s
</date>

<title>
%s
</title>

<body>
%s
</body>

</blog>
" timestring subject body)))

    (setq *lastcontent* content)

    (write-region content nil file)
    )
  )

(defun nthblog (rel)
  ; assert: in a blog buffer
  (unless (string-match *blog-home* default-directory)
    (lastblog))

  (let ((l (allblogs))
	(this (file-name-nondirectory (buffer-file-name))))
    (if (member this l)
	(progn 
	  (while (not (string= this (car l)))
	    (setq l (roll l))
	    )
	  (if (< rel 0)
	      (nth (- rel) (reverse l))
	    (nth rel l))
	  )
      )
    )
  )
; (nthblog -1)

(defun lastblog (&optional arg) 
  "visit the last blog edited"
  (interactive "P")

  (let* ((default-directory (format  "%s/dscm/%s" my-documents *default-area*))
	 (files (loop for x in (get-directory-files  ".") when (not (or (file-directory-p x) (string-match "~" x))) collect x))
	 (thing (first (sort* files '(lambda (x y) (string-lessp y x))))))

    (if arg
	(let ((url (concat *blog-home-url* "/?pat=" thing "&raw")))
	  (w3m-goto-url url)
	  )
      (find-file thing)
      )
    )
  )

;; xxx wet paint
(defun nextblog (&optional arg) 
  "visit the blog prior to this one"
  (interactive "p")

  (let* ((default-directory (format  "%s/dscm/%s" my-documents *default-area*))
	 (n arg)
	 )
    (find-file  (nthblog n))
    )
  )
(global-set-key "\M-n" 'nextblog)

(defun priorblog (&optional arg) 
  "visit the blog prior to this one"
  (interactive "p")

  (let* ((default-directory (format  "%s/dscm/%s" my-documents *default-area*))
	 (n (- arg))
	 )
    (find-file  (nthblog n))
    )
  )
(global-set-key "\M-p" 'priorblog)

(defun grepblog (pat) 
  "grep for pat among blogs"
  (interactive "spat: ")
  (let ((default-directory (format  "%s/dscm/%s/" my-documents *default-area*)))
    (grep (format "%s %s *" grep-command pat))
    )
  )

(require 'ctl-slash)
(define-key ctl-/-map "w" 'myblog)
(define-key ctl-/-map "l" 'lastblog)
(define-key ctl-/-map "a" 'grepblog)

(provide 'myblog)


;; fancy
(defun qc (expr)
  "perform a quick calculation of expression like '100 + 1000' or 'x  + y' assuming both are bound
evaluation of variables is done like that in `backquote`
supports big ints"
  (let* (
	 (l (loop for a in (split expr)
		  collect
		  (let ((s (intern a)))
		    (if (boundp s)
			(let ((v (eval s)))
			  (cond ((stringp v) v)
				((integerp v) (format "%d" v))))
		      a)
		    )
		  ))
	 (sexpr (mapconcat 'identity l " ")))
    (eval-process "perl" "-e" (concat "print " sexpr))
    )
  )

; (let* ((x 100) (y 1000)) (qc "x + y"))

;;; xxx police line do not cross
(defun datestamp (spec)
  "spec can be a mixed argument like -1d meaning yesterday or +1h meaning one hour from now"
  (let ((sec (eval-process "date" "+%s"))
	(factor 1) (nsec 1) (deltasec 0) otherdate)

    (cond ((string-match "h$" spec)
	   (setq factor (* 60 60))
	   (setq spec (substring spec 0 (match-beginning 0))))
	  ((string-match "m$" spec)
	   (setq factor 60)
	   (setq spec (substring spec 0 (match-beginning 0))))
	  ((string-match "s$" spec)
	   (setq factor 1)
	   (setq spec (substring spec 0 (match-beginning 0))))
	  ((string-match "d$" spec)
	   (setq factor (* 60 60 24))
	   (setq spec (substring spec 0 (match-beginning 0))))
	  ((string-match "w$" spec)
	   (setq factor (* 7 60 60 24))
	   (setq spec (substring spec 0 (match-beginning 0))))
	  (t ;; default is secs
	   (setq factor 1)
	   ))

    (cond ((string-match "^+$" spec)
	   (setq spec (substring spec (match-end 0))))
	  ((string-match "^-$" spec)
	   (setq factor (- factor))
	   (setq spec (substring spec (match-end 0))))
	  )

    (setq delta (read spec))

;; stupid lisp arithmetic cant handle this calculation
;   (setq sec (+ (read sec) (* factor delta)))
 
    (setq sec (qc (format "%s + (%d * %d)" sec factor delta)))

    (setq otherdate (mktime sec t))

  ; assert spec is a string representation of a valid integer

    (eval-process "date" "+%y%m%d%H%M%S" (format "--date=%s" otherdate))
    )
  )
; produce a datestamp for yesterday
; (datestamp "-1d")
; (datestamp "-3d")
; (datestamp "-3h")

(defun mktime (&optional sec reverse)
  (let ((v
	 (cond ((and sec reverse)
		(apply 'eval-process (list "mktime" "-v" sec)))
	       (sec
		(apply 'eval-process (list "mktime" sec)))
	       (t
		(apply 'eval-process (list "mktime")))
	       )))
    (chomp (chomp v))
    )
  )

; (mktime "1141230058" t)
; (mktime)

(defun allblogs ()
  (let* ((default-directory (format  "%s/dscm/%s" my-documents *default-area*))
	 (files (loop for x in (get-directory-files  ".") when (not (or (file-directory-p x) (string-match "~" x))) collect x)))
    files)
  )
; (allblogs)

(defun rawblog (thing)
  (interactive
   (list (completing-read "thing: " (loop for x in (allblogs) collect (list x x)) nil t)))

  (let ((url (concat *blog-home-url* "/?pat=" thing "&raw")))
    (w3m-goto-url url)
    )
  )
