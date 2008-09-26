(put 'myblog 'rcsid
 "$Id: myblog.el,v 1.19 2008-09-26 00:14:32 keystone Exp $")

;; myblog

(require 'locations)
(require 'mktime)
(require 'psgml)

;; this stuff should be in db, presentation layer should do all formatting.
;; tbd function to adjust modtimes on files, when organized by datestamp.  see modtime.el

; tbd move these somewhere more sensible...
(defvar *blog-dtd* "/content/dtd/blog.dtd")
; this should convert blog to html then format the html as text...
; maybe use apache fop?
; <xsl:output method="html"/>
(defvar *blog2text* "/z/dscm/xsl/blog2text.xsl")
(defvar *blog2title* "/z/dscm/xsl/blog2title.xsl")

(defvar *blog-doctype* (format "<!DOCTYPE BLOG SYSTEM \"%s\">"  *blog-dtd*))
(defvar *blog-home-url* "http://localhost:20080")
(defvar *blog-home* (expand-file-name "/content"))
(defvar *blog-pattern* "^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$")
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

; tbd utf-8 codepage indicator, fancy xmlns
(defun format-blog-entry (timestring subject body)
  (format "%s
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
" 
	  *blog-doctype* timestring subject body)
  )

(defun myblog (&optional datestamp) (interactive)
  (let* (
	 (area (setq *default-area* (completing-read (format "area (%s): " *default-area*) *areas* nil t nil nil *default-area*)))
	 (subject1 (read-string "subject: "))
	 (timestring (format-time-string "%y%m%d %H:%M:%S"))
	 (file (generate-dscm-entry-name area))
	 (body (fix-utf8-chars-in-string (get-scratch-buffer-contents "*blog*")))
	 (subject (or (string* subject1 (read-string "subject: "))))
	 (content (format-blog-entry timestring subject body)))

    (setq *lastcontent* content)

    (write-region content nil file)
    )
  )

(defun isblog ()
  (and (not (null (buffer-file-name))) (string-match *blog-pattern* (file-name-nondirectory (buffer-file-name))))
  )
; (isblog)

(defun nthblog (rel)
  "when in a blog buffer; return the Nth blog relative to the current one
N may be negative.  returns nil if out of bounds
" 
  ; assert: in a blog buffer
  (unless (isblog)
    (error "not in a blog buffer"))

  (unless (string-match *blog-home* default-directory)
    (lastblog))

  (let* ((l (allblogs))
	 (v (apply (quote vector) l))
	 (len (length v))
	 (this (file-name-nondirectory (buffer-file-name)))
	 (n (+ (loop for i from 0 to len when (string= this (aref v i)) return i) rel))
	 )

    (and (>= n 0) (< n len) (aref v n))
    )
  )
; (nthblog -1)

(defun blog2text (blogfile)
  (interactive (list
		(read-string* " blogfile (%s): " (lastblog))
		))
  (let* ((text (eval-process "xsltproc" *blog2text* blogfile))
	 (b (zap-buffer "*lastblog*" 'blog-view-mode)))
    (set-buffer b)
    (insert text)

    (beginning-of-buffer)
    (set-buffer-modified-p nil)
    (setq buffer-read-only t)
    (view-mode)
    (switch-to-buffer b)
    )
  )

(defun blog2title (blogfile)
  "evaluates to the titlestring of a blog
"
  (interactive (list
		(read-string* " blogfile (%s): " (lastblog))
		))
  (let* ((text (eval-process "xsltproc" *blog2title* blogfile)))

    (if (interactive-p) (message text) text)
    )
  )

(defun thisblog2text ()  (interactive) (blog2text (buffer-file-name)))

(require 'filetime)

(defun sort-files-by-name (files) (sort* (copy-list files) '(lambda (x y) (string-lessp y x))))
(defun sort-files-by-modtime (files) (sort* files '(lambda (x y) (= (compare-filetime (filemodtime y) (filemodtime x)) -1))))

(defun default-area (&optional arg)
  (if arg 
      (setq *default-area* (completing-read (format "area (%s): " *default-area*) *areas* nil t nil nil *default-area*))
    *default-area*)
  )

(defun get-blog-files (&optional dir)
  (interactive)
  (let ((dir (or dir ".")))
    (loop for x in (get-directory-files dir)
	  when (not (or (file-directory-p x) (string-match "~$" x) (string-match "^#" x)))
	  collect x)
    )
  )

(defun find-blog (f)
  (find-file f)
  (blog-mode)
  )

(defun find-lastblog (&optional arg) 
  "visit the last blog edited
 with optional ARG, prompts for area.
"
  (interactive "P")
  (find-blog (lastblog arg))
  )

(defun lastblog (&optional arg) 
  " returns the filename of the last blog edited
with optional ARG, prompts for area.
"
  (interactive "P")

  (let* ((default-directory (format  "%s/%s" *blog-home* (default-area arg)))
	 (files 
	  (sort-files-by-modtime (get-blog-files)))
	 (thing (first files)))
    (expand-file-name thing)
    )
  )
; (lastblog)

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
  (interactive "P")

  (let* ((default-directory (blog-context))
	 (n (or arg 1))
	 (blog (nthblog n))
	 )
    (if (and (null blog) (interactive-p))
	(message "no next blog")
      (find-blog blog)
      )
    )
  )

(defun priorblog (&optional arg) 
  "visit the blog prior to this one"
  (interactive "P")

  (let* ((default-directory (blog-context))
	 (n (or arg -1))
	 (blog (nthblog n))
	 )

    (if (and (null blog) (interactive-p))
	(message "no prior blog")
      (find-blog blog)
      )
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




(require 'timezone)

(defun allblogs ()
  (let* ((default-directory (blog-context))
	 (files (get-directory-files  "." nil *blog-pattern*)))
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

(define-derived-mode blog-mode xml-mode "blog"

  (setq fill-column 164)
  (auto-fill-mode 1)
  )

(define-key blog-mode-map "\M-n" 'nextblog)
(define-key blog-mode-map "\M-p" 'priorblog)
(define-key blog-mode-map (vector 'f1) 'thisblog2text)

(define-derived-mode blog-view-mode fundamental-mode "blog view")
(define-key blog-mode-map "\M-n" 'viewnextblog)
(define-key blog-mode-map "\M-p" 'viewpriorblog)

(defun whatblog () (file-name-nondirectory (buffer-file-name)))
(defun allblogs () (sort (get-directory-files nil nil "^[0-9]*$") 'string-lessp))
(defun viewnextblog () (interactive)
  (let* ((thisblog (whatblog))
	 (nextblog (loop with next = nil
			 for x across (apply 'vector (allblogs))
			 when next return x
			 do (if (string= x thisblog) (setq next t))
			 )))
    (if nextblog (find-blog nextblog) (error "no more blogs"))
    )
  )
(defun viewpriorblog () (interactive)
  (let* ((thisblog (whatblog))
	 (priorblog (loop with prior = nil
			  for x across (apply 'vector (allblogs))
			  when (string= x thisblog) return prior
			  do (setq prior x)
			  )))
    (if priorblog (find-blog priorblog) (error "no more blogs"))
    )
  )

; tbd -- wha?
(condition-case x
    (require 'ctl-dot)
  (define-key ctl-.-map "o" 'myblog)
  (define-key ctl-.-map "l" 'find-lastblog)
  (define-key ctl-.-map "g" 'grepblog)
  (define-key ctl-.-map "b" 'blog2text)
  (error (debug))
  )

(provide 'myblog)

