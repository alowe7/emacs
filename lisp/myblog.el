(put 'myblog 'rcsid
 "$Id: myblog.el,v 1.16 2008-01-23 05:51:11 alowe Exp $")

;; myblog

(require 'locations)
(require 'mktime)
(require 'psgml)

;; this stuff should be in db, presentation layer should do all formatting.
;; tbd function to adjust modtimes on files, when organized by datestamp.  see modtime.el


(defvar *blog-home-url* "http://localhost:20080")
(defvar *blog-home* (expand-file-name "/content"))

(defvar *areas*
  (loop for x in  (split (eval-process  (format "find %s -mindepth 1 -maxdepth 1 -type d" *blog-home*)) "\n") collect (list  (file-name-nondirectory x)))
)
; (defvar *areas* '((".net") ("biz") ("crypto") ("dcgs") ("j2ee") ("personal") ("tech") ("pub") ("priv")))

(defvar *default-area* "personal")

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
  (if (string= area "priv")
      (format  "%s/%s/%s"  (expand-file-name "~") ".private/blog" (format-time-string "%y%m%d%H%M%S"))
    (format  "%s/%s/%s"  *blog-home* area (format-time-string "%y%m%d%H%M%S"))
    )
  )

;; tbd: encode entities in content.  e.g. "&" -> "&amp;"

(defun fix-utf8-chars-in-string (s)
  (let ((utf8-chars '(("\205" "...") ("\222" "\'") ("\223" "\"") ("\224" "\""))))
    (loop for x in utf8-chars do (setq s (replace-regexp-in-string (car x) (cadr x) s)))
    s)
  )

(defun myblog (&optional datestamp) (interactive)
  (let* (
	 (area (setq *default-area* (completing-read (format "area (%s): " *default-area*) *areas* nil t nil nil *default-area*)))
	 (subject1 (read-string "subject: "))
	 (timestring (format-time-string "%y%m%d %H:%M:%S"))
	 (file (generate-dscm-entry-name area))
	 (body (fix-utf8-chars-in-string (get-scratch-buffer-contents "*blog*")))
	 (subject (or (string* subject1 (read-string "subject: "))))
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
<![CDATA[
%s
]]>
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

(require 'filetime)

(defun sort-files-by-name (files) (sort* (copy-list files) '(lambda (x y) (string-lessp y x))))
(defun sort-files-by-modtime (files) (sort* files '(lambda (x y) (= (compare-filetime (filemodtime y) (filemodtime x)) -1))))

(defun default-area (&optional arg)
  (if arg 
      (completing-read (format "area (%s): " *default-area*) *areas* nil t nil nil *default-area*)
    *default-area*)
  )

(defun get-blog-files (&optional dir)
  (interactive)
  (let ((dir (or dir ".")))
    (loop for x in (get-directory-files dir)
	  when (not (or (file-directory-p x) (string-match "~" x)))
	  collect x)
    )
  )

(defun lastblog (&optional arg) 
  "visit the last blog edited
with optional ARG, prompts for area.
"
  (interactive "P")

  (let* ((default-directory (format  "%s/%s" *blog-home* (default-area arg)))
	 (files 
	  (sort-files-by-modtime (get-blog-files)))
	 (thing (first files)))
    (find-file thing)
    )
  )

(defun w3m-lastblog (&optional arg)
  (interactive "P")

  (let ((url (concat *blog-home-url* "/?pat=" thing "&raw")))
    (w3m-goto-url url)
    )
  )

;; xxx wet paint
(defun blog-context ()
  (format  "%s/%s" *blog-home* *default-area*)
)

(defun nextblog (&optional arg) 
  "visit the blog prior to this one"
  (interactive "p")

  (let* ((default-directory (blog-context))
	 (n arg)
	 )
    (find-file  (nthblog n))
    )
  )

(defun priorblog (&optional arg) 
  "visit the blog prior to this one"
  (interactive "p")

  (let* ((default-directory (format  "%s/dscm/%s" my-documents *default-area*))
	 (n (- arg))
	 )
    (find-file  (nthblog n))
    )
  )

(defun grepblog (pat) 
  "grep for pat among blogs"
  (interactive "sgrep blogs for: ")
  (let ((default-directory (format  "%s/%s/" *blog-home* *default-area*)))
  ; need sh -c to get wildcard expansion to work right
    (grep (format "sh -c '%s %s *[^~]'" grep-command pat))
    )
  )

(require 'ctl-slash)
(define-key ctl-/-map "o" 'myblog)
(define-key ctl-/-map "l" 'lastblog)
(define-key ctl-/-map "g" 'grepblog)

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
(defun datestamp (&optional spec)
  "spec can be a mixed argument like -1d meaning yesterday or +1h meaning one hour from now"
  (interactive)

  (let ((spec (or spec "0"))
	(sec (eval-process "date" "+%s"))
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
    (let ((v 
	   (kill-new (eval-process "date" "+%y%m%d%H%M%S" (format "--date=%s" otherdate)))))
      (if (interactive-p) (message v))
      v)
    )
  )
; produce a datestamp for yesterday
; (datestamp "-1d")
; three days ago
; (datestamp "-3d")
; three hours ago
; (datestamp "-3h")
; now
; (datestamp)
(require 'timezone)

(defun allblogs ()
  (let* ((default-directory (blog-context))
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

(define-derived-mode blog-mode xml-mode "blog")
(define-key blog-mode-map "\M-n" 'nextblog)
(define-key blog-mode-map "\M-p" 'priorblog)
