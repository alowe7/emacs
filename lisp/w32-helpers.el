(unless (fboundp 'ctl-RET-prefix) 
    (define-prefix-command 'ctl-RET-prefix))

(unless (and (boundp 'cmd-map) cmd-map)
  (setq cmd-map  (symbol-function 'ctl-RET-prefix)))

(global-set-key  (vector 'C-return) 'ctl-RET-prefix)


(loop for x from 0 to 4 do 
      (eval
       `(define-key cmd-map ,(format "%d" x)
	  '(lambda () (interactive) (shell2 ,x )))
       )
      )

(define-key cmd-map "1" 
  '(lambda () (interactive) (shell2 1 )))

(define-key cmd-map "2" 
  '(lambda () (interactive) (shell2 2 )))

(define-key cmd-map "3" 
  '(lambda () (interactive) (shell2 3 )))

(define-key cmd-map "4" 
  '(lambda () (interactive) (shell2 3 )))


