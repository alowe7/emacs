(put 'post-sgml-mode 'rcsid 
 "$Id: post-sgml-mode.el,v 1.9 2001-12-06 19:57:59 cvs Exp $")
;(setq html-mode-hook '(lambda () (setq paragraph-start "<P>"))

(setq sgml-mode-hook '(lambda () (run-hooks 'html-mode-hook)
  ;			(require 'sgml-helpers)
  ;			(define-key sgml-mode-map "" 'docbook-help)
	     (setq tab-width 4)
	     (turn-on-lazy-lock)
			))

(defun html-quick-view (fn)
  (perl-command "fast-html-format" fn)
  (pop-to-buffer " *perl*")
  (rename-buffer (concat fn " *html*") t)
  (beginning-of-buffer)
  )

(defun html-quick-view-buffer ()
  (interactive)
  (let* ((fn (or (buffer-file-name)
		 (prog1 (setq fn (mktemp (gensym "_")))
		   (write-region (buffer-string) nil fn)))))
    (html-quick-view fn)
    )
  )

(defun html-quick-find-file (fn)
  (interactive "ffile: ")
  (html-quick-view fn)
  )

(setq html-mode-hook '(lambda () 

			(define-key html-mode-map "" 'html-quick-view-buffer)
			(define-key html-mode-map "" 'html-quick-find-file)

			(define-key html-mode-map "w" '(lambda () (interactive)
							   (w3-parse-partial (buffer-string)))) 
			) 
      )


(defun xml-beautify () (interactive)
  (save-excursion
    (replace-string "><" ">
<" )
    )
  )

(defun beautify-config () 
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^[ 	]+" nil t)
      (replace-match "" nil t))
    (while (search-forward  "><" nil t)
      (replace-match ">
<" nil t))
    (loop for x in '("<worknodes") 
	  with n = 0
	  do
	  (setq n (+ n 4))
	  (goto-char (point-min))
	  (search-forward x)
	  (beginning-of-line)
	  (let ((p (point)))
	    (sgml-skip-tag-forward 1)
	    (indent-rigidly p (point) n)
	    ))
    )
  (lazy-lock-mode)
  (set-buffer-modified-p nil)
  )

(define-key sgml-mode-map (vector 'f10) 'beautify-config)

(defun maybe-beautify ()
  (save-excursion
    (goto-char (point-min))
    (if (search-forward "<IDictionaryRoot" nil t)
  ; yep, its a config, beautify it
	(beautify-config)
      )))

(add-hook 'sgml-mode-hook 'maybe-beautify)
