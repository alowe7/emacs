(put 'post-comint 'rcsid 
 "$Id: post-comint.el,v 1.17 2003-03-13 17:51:11 cvs Exp $")

;; used to initialize `comint-mode-hook'
; (setq shell-prompt-pattern "^[0-9]+% *")
(setq shell-prompt-pattern "^[0-9]+[#%] *")

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