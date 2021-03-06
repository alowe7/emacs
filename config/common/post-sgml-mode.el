(put 'post-sgml-mode 'rcsid 
 "$Id$")
;(setq html-mode-hook (lambda () (setq paragraph-start "<P>"))

;; (setq sgml-mode-hook (lambda () (run-hooks 'html-mode-hook)
;;   ;			(require 'sgml-helpers)
;;   ;			(define-key sgml-mode-map "" 'docbook-help)
;; 	     (setq tab-width 4)
;; 	     (turn-on-lazy-lock)
;; 			))

(defun html-quick-view (fn)
  (perl-command "fast-html-format" fn)
  (pop-to-buffer " *perl*")
  (rename-buffer (concat fn " *html*") t)
  (goto-char (point-min))
  )

(defun html-quick-view-buffer ()
  (interactive)
  (let* ((fn (or (buffer-file-name)
		 (prog1 (setq fn (make-temp-file (gensym "_")))
		   (write-region (buffer-string) nil fn)))))
    (html-quick-view fn)
    )
  )

(defun html-quick-find-file (fn)
  (interactive "ffile: ")
  (html-quick-view fn)
  )

(setq html-mode-hook (lambda () 

			(define-key html-mode-map "" 'html-quick-view-buffer)
			(define-key html-mode-map "" 'html-quick-find-file)

			(define-key html-mode-map "w" (lambda () (interactive)
							   (w3-parse-partial (buffer-string)))) 
			) 
      )





; (define-key sgml-mode-map (vector 'f10) 'beautify-config)

; (define-key sgml-mode-map "" 'forward-char)
; (define-key sgml-mode-map "" 'find-file-force-refresh)
