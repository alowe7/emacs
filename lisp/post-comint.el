(put 'post-comint 'rcsid 
 "$Id: post-comint.el,v 1.23 2003-10-24 13:24:53 cvs Exp $")

(setq explicit-bash-args '("-i"))

(defun comint-last-arg () 
  "insert last arg from `comint-previous-input-string`"
  (interactive)
  (insert (car (last (split (comint-previous-input-string 0)))))
  )

(require 'ctl-ret)

(defvar *max-ret-shells* 9)
(loop for x from 0 to *max-ret-shells* do 
      (eval
       `(define-key ctl-RET-map ,(format "%d" x)
	  '(lambda () (interactive) (shell2 ,x ))))
      )

(define-key comint-mode-map "." 'comint-last-arg)
(define-key comint-mode-map "	" 'comint-dynamic-complete-filename)
(define-key comint-mode-map "	" 'comint-dynamic-complete)

(define-key ctl-RET-map (vector ?\C-7) 'lru-shell)
(define-key ctl-RET-map (vector ?\C-8) 'mru-shell)

(require 'ctl-slash)

; grab dir from context of other window and insert it here.  if only one window showing, then current dir
(define-key ctl-/-map "0" '(lambda () (interactive) (insert (save-window-excursion (other-window-1) (canonify (or (buffer-file-name) default-directory) 0)))))
