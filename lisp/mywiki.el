(put 'mywiki 'rcsid
 "$Id: mywiki.el,v 1.1 2006-02-08 15:45:22 alowe Exp $")

;; mywiki

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
  (format  "%s/dscm/%s/%s.php" my-documents area (format-time-string "%y%m%d%H%M%S"))
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
<div class=\"blog\">

<h2 class=\"date\">
%s
</h2>

<div class=\"blogbody\">

<h3 class=\"title\">
%s
</h3>

%s
</div>

</div>
" timestring subject 
(replace-regexp-in-string "
" "<br/>
" body))))

    (setq *lastcontent* content)

    (write-region content nil file)
    )
  )

(require 'ctl-slash)
(define-key ctl-/-map "w" 'mywiki)

(provide 'mywiki)
