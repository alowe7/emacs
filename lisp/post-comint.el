(put 'post-comint 'rcsid 
 "$Id: post-comint.el,v 1.15 2002-05-08 15:35:21 cvs Exp $")

;; used to initialize `comint-mode-hook'
(setq shell-prompt-pattern "^[0-9]+% *")

(setq explicit-bash-args '("-i"))

(defun comint-last-arg () 
  "insert last arg from `comint-previous-input-string`"
  (interactive)
  (insert (car (last (split (comint-previous-input-string 0)))))
  )


(unless (fboundp 'ctl-RET-prefix) 
    (define-prefix-command 'ctl-RET-prefix))

(unless (and (boundp 'ctl-RET-map) ctl-RET-map)
  (setq ctl-RET-map (symbol-function 'ctl-RET-prefix)))

; apparently C-RET is not a good prefix key if you're on telnet session
(if window-system
    (global-set-key  (vector 'C-return) 'ctl-RET-prefix)
  (global-set-key "\C-j" 'ctl-RET-prefix)
  )

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