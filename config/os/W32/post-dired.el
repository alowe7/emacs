(put 'post-dired 'rcsid
 "$Id: post-dired.el,v 1.7 2009-10-12 03:23:59 alowe Exp $")

(chain-parent-file t)

; tbd promote these...

(defun dired-copy-filename-as-kill (arg) 
  "apply `kill-new' to `dired-get-filename'"
  (interactive "P")
  (let* ((of (or (dired-get-filename nil t) default-directory))
	 (f (funcall (if arg 'w32-canonify 'identity) of)))
    (kill-new f)
    (if (interactive-p) (message f))
    )
  )
(define-key dired-mode-map "\C-cw" 'dired-copy-filename-as-kill)

(defun dired-copy-directory-as-kill (arg) 
  "apply `kill-new' to `dired-get-filename'"
  (interactive "P")
  (let* ((f (funcall (if arg 'w32-canonify 'identity) (dired-current-directory))))
    (kill-new f)
    (if (interactive-p) (message f))
    )
  )

(define-key dired-mode-map "\C-c\C-x\C-c" 'dired-copy-directory-as-kill)


; override to expand default-directory... w32 only

(defun dired-read-dir-and-switches (str)
  ;; For use in interactive.
  (reverse (list
	    (if current-prefix-arg
		(read-string "Dired listing switches: "
			     dired-listing-switches))
	    (read-file-name (format "Dired %s(directory): " str)
			    nil (expand-file-name default-directory) nil))))


;; special case for disambiguation of multiple drive letters 
(defadvice expand-file-name (around 
			     hook-expand-file-name
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
; (if (ad-is-advised 'expand-file-name) (ad-unadvise 'expand-file-name))

; (expand-file-name  "c:/home/a/emacs/lisp/v:")
; (expand-file-name  "c:/home/a/emacs/lisp/")
; (expand-file-name  "/home/a/emacs/lisp")



