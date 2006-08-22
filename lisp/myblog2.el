(put 'myblog2 'rcsid
 "$Id: myblog2.el,v 1.3 2006-08-22 00:51:09 alowe Exp $")

; clean room version of MyBlog that uses asp

(require 'eval-process)

(defvar *basedir* (expand-file-name "/content/"))

(defun myblog2 (&optional datestamp)
  (interactive)
  (let ((datestamp (or datestamp (eval-process "date +%y%m%d%H%M%S"))))
    (find-file (concat *basedir* datestamp))
    )
  )

(defun dired-blog-from-file-date ()
  "generate a blog having the encoded time of `dired-get-filename'"
  (interactive)
  (let ((s (format-time-string "%y%m%d%H%M%S" (nth 5 (file-attributes (dired-get-filename))))))
    (myblog2 s)
    )
  )

(defun expand-as-local-url (x)
)

(defun lastblog (&optional arg)
  "pop to most recent blog entry.
with arg, navigate to using `w3m`
non-interactively just return filename (also adds to kill ring using `kill-new`)
non-interactively with arg, likewise, with url instead of filename
"
  (interactive "P")
  (let* ((default-directory *basedir*)
	 (files 
	  (sort*
	   (loop for x in (directory-files ".")
		 unless (or (file-directory-p x) (string-match "^[^0-9]\\|~$" x))
		 collect x)
	   '(lambda (x y) (string-lessp y x)))))

    (cond ((and (not (interactive-p)) arg)
	   (expand-as-local-url (car files)))
	  ((not (interactive-p)) (expand-file-name (car files)))
	  (arg (w3m (expand-file-name (car files))))
	  (t (find-file (car files)) )
	  )
    )
  )

; tbd add-to-load-hook
(and (boundp 'dired-mode-map)
     (define-key dired-mode-map "w" 'dired-blog-from-file-date)
     )

(defun grepblog (arg)
  (interactive "P")
  (let* ((default-directory *basedir*)
	 (pat (read-string "grep for: "))
	 )

    (grep (concat "grep -n -i -e " pat " [0-9]*" ))
    )
  )

(define-derived-mode blog-mode text-mode "BLOG")

(defun blog-find-file-hook ()
  (if (string-match (expand-file-name *basedir*)  default-directory)
      (blog-mode))
  )

(defun this-blog ()
  "returns a list of blogs ring sorted with this one in front"
  (let* ((l (sort* (get-directory-files nil "^[0-9]+$") 'string-lessp))
	 (b (file-name-nondirectory (buffer-file-name)))
	 (n (length l)) (i 0)
	 )
    (while (and (< i n) (not (string= b (car l)))) (roll l) (setq i (1+ i)))
    l)
  )
(defun previous-blog ()
  (interactive)
  (find-file (car (last (this-blog))))
  )

(defun next-blog ()
  (interactive)
  (find-file (cadr (this-blog)))
  )
(define-key blog-mode-map "\M-p" 'previous-blog)
(define-key blog-mode-map "\M-n" 'next-blog)

(require 'ctl-slash)
(define-key ctl-/-map "g" 'grepblog)
(define-key ctl-/-map "l" 'lastblog)

; if you are looking at a file in *basedir*, assume its a blog
(add-hook 'find-file-hooks 'blog-find-file-hook)

(provide 'myblog2)
