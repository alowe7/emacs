(put 'post-comint 'rcsid 
 "$Id: post-comint.el,v 1.8 2001-03-19 10:41:53 cvs Exp $")

(setq comint-prompt-regexp "^[0-9a-zA-Z]*% *")

(setq explicit-bash-args '("-login" "-i"))


(defun comint-last-arg () 
  "insert last arg from `comint-previous-input-string`"
  (interactive)
  (insert (car (last (split (comint-previous-input-string 0)))))
  )

(define-key comint-mode-map "." 'comint-last-arg)


(unless (fboundp 'ctl-RET-prefix) 
    (define-prefix-command 'ctl-RET-prefix))

(unless (and (boundp 'ctl-RET-map) ctl-RET-map)
  (setq ctl-RET-map (symbol-function 'ctl-RET-prefix)))

(global-set-key  (vector 'C-return) 'ctl-RET-prefix)

(defvar *max-ret-shells* 5)
(loop for x from 0 to *max-ret-shells* do 
      (eval
       `(define-key ctl-RET-map ,(format "%d" x)
	  '(lambda () (interactive) (shell2 ,x ))))
      )
