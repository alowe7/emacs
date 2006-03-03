(put 'mywiki 'rcsid
 "$Id: mywiki.el,v 1.5 2006-03-03 20:24:26 alowe Exp $")

;; mywiki

(require 'locations)

;; this stuff should be in db, presentation layer should do all formatting.

(defvar *areas* '((".net") ("biz") ("crypto") ("dcgs") ("j2ee") ("personal") ("tech") ("pub")))
(defvar *default-area* "pub")

(defvar *mywiki-db* (expand-file-name "~/.dscm"))

(defun persist-mywiki-state ()
  (write-region (format "%s\n" *default-area*) nil *mywiki-db*)
  )

(defun restore-mywiki-state ()
  (let ((s (read-file *mywiki-db*)))
    (and (string* s) (setq *default-area* s))
    )
  )

(restore-mywiki-state)

(add-hook 'kill-emacs-hook 'persist-mywiki-state)

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
  (format  "%s/dscm/%s/%s" my-documents area (format-time-string "%y%m%d%H%M%S"))
  )

(defun mywiki () (interactive)
  (let* (
	 (area (setq *default-area* (completing-read (format "area (%s): " *default-area*) *areas* nil t nil nil *default-area*)))
	 (subject (read-string "subject: "))
	 (timestring (format-time-string "%y%m%d %H:%M:%S"))
	 (file (generate-dscm-entry-name area))
	 (body (get-scratch-buffer-contents "*wiki*"))
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

(defun lastwiki () 
  "visit the last wiki edited"
  (interactive)

  (let* ((default-directory (format  "%s/dscm/%s" my-documents *default-area*))
	 (files (loop for x in (get-directory-files  ".") when (not (file-directory-p x)) collect x)))

    (find-file
     (car (sort* files '(lambda (x y) (string-lessp y x))))))
  )

(defun grepwiki (pat) 
  "grep for pat among wikis"
  (interactive "spat: ")
  (let ((default-directory (format  "%s/dscm/%s/" my-documents *default-area*)))
    (grep (format "%s %s *" grep-command pat))
    )
  )

(require 'ctl-slash)
(define-key ctl-/-map "w" 'mywiki)
(define-key ctl-/-map "l" 'lastwiki)
(define-key ctl-/-map "a" 'grepwiki)

(provide 'mywiki)


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

