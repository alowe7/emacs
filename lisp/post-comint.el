(put 'post-comint 'rcsid 
 "$Id: post-comint.el,v 1.18 2003-05-15 21:00:02 cvs Exp $")

;; used to initialize `comint-mode-hook'
(mapcar '(lambda (f) (apply f '(comint-prompt-regexp "^[a-zA-Z0-9]*[>$%] *"))) '(set-default set))

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

(define-key ctl-RET-map (vector ?\C-7) 'mru-shell)