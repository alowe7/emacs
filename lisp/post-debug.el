(put 'post-debug 'rcsid "$Id: post-debug.el,v 1.6 2000-10-03 16:44:07 cvs Exp $")
; (define-key debugger-mode-map "x" 'debug-indicated-word)

;(add-hook 'debugger-mode-hook '(lambda ()
; (define-key debugger-mode-map "x" '(lambda () (interactive) 
; (let ((fn  (intern (indicated-word))))
; (cond ((member fn debug-function-list)
;   (cancel-debug-on-entry  fn)
;   (message "debugging canceled for function %s" fn))
; (t (message "function %s is not marked for debugging" fn)))
; ))
;)))



(defun debug-on-error () 
  "toggle state of debug-on-error variable"
  (interactive)
  (setq debug-on-error (not debug-on-error))
  (message "debug-on-error %s" (if debug-on-error "enabled" "disabled"))
  )
