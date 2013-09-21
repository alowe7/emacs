
(defvar *pydoc-command* "/bin/pydoc")

(defun pydoc (thing)
  (interactive (list (read-string* "pydoc for (%s): " (thing-at-point 'word))))
  (let (temp-buffer-show-hook)
    (add-hook 'temp-buffer-show-hook
	      (function (lambda ()
			  (qsave-search (current-buffer) thing)
			  (pydoc-mode)
			  )))
    (with-output-to-temp-buffer "*pydoc*" 
      (princ (eval-python-process  *pydoc-command* thing))
      )
    )
  )
; (pydoc "sys")
; (pydoc "pydoc")
(define-key help-map "\C-p" 'pydoc)

(require 'qsave)
(define-derived-mode pydoc-mode help-mode "Pydoc")

(add-hook 'pydoc-mode-hook 
	  (function
	   (lambda () 
	     (define-key pydoc-mode-map "\M-p" 'roll-qsave)
	     (define-key pydoc-mode-map "\M-n" 'roll-qsave-1)
	     )))


(require 'info-look)

(info-lookup-add-help
 :mode 'python-mode
 :regexp "[[:alnum:]_]+"
 :doc-spec
 '(("(python)Index" nil "")))

(provide 'pydoc)
