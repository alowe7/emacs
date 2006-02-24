(put 'mywiki 'rcsid
 "$Id: mywiki.el,v 1.4 2006-02-24 16:24:44 alowe Exp $")

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
" timestring subject 
(replace-regexp-in-string "
" "<br/>
" body))))

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


(require 'ctl-slash)
(define-key ctl-/-map "w" 'mywiki)
(define-key ctl-/-map "l" 'lastwiki)

(provide 'mywiki)
