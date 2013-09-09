(put 'autosense 'rcsid
 "$Id$")

; provides syntax relevant autocompletion based on major mode

; this is for emacs-lisp mode.
; tbd handle other modes -- see java-bones and ant-bones

(require 'cl)
(require 'fapropos)
(require 'cat-utils)
(require 'typesafe)

(defun autosense ()
  (interactive)
  (let* ((bounds (bounds-of-thing-at-point 'word))
	 (word (thing-at-point 'word))
	 (completions (mapcar (lambda (x) (list (symbol-name x) x)) (symbols-like (concat "^" word))))
	 (completion (and completions
			  (cond ((= (length completions) 1) (caar completions))
				(t (completing-read  "Complete: " completions nil nil word))))))

    (if completion 
	(progn 
	  (kill-region (car bounds) (cdr bounds))
	  (insert completion)
	  (describe-function-briefly (cadr (assoc completion completions))))
      )
    )
  )

(defun describe-function-briefly (f)
  (interactive "afunction: ")
  (let* ((lines (loop for x in (split (documentation f) "\n") when (string* x) collect x))
	 (line (car lines)))
    (and line (message line))
    )
  )


; (define-key emacs-lisp-mode-map "\M-." 'autosense)
(global-set-key  "\M-." 'autosense)
