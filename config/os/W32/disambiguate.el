(require 'long-comment)

;; this is currently broken..

(/*
 ;; special case for disambiguation of multiple drive letters 
 (defadvice expand-file-name (around 
			      w32-hook-expand-file-name
			      first activate)
   ""

   (let (
	 (name (ad-get-arg 0))
	 (pos 0) prev)
     (while (setq pos (string-match ":" name (1+ pos))) (setq prev pos))

     (when prev 
       (ad-set-arg 0
		   (substring name (1- prev) (length name)))
       )

     ad-do-it
     )

   )
 )

; (if (ad-is-advised 'expand-file-name) (ad-unadvise 'expand-file-name))

; (expand-file-name  "c:/home/a/emacs/lisp/v:")
; (expand-file-name  "c:/home/a/emacs/lisp/")
; (expand-file-name  "/home/a/emacs/lisp")
