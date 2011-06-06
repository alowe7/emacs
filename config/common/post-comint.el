(put 'post-comint 'rcsid 
 "$Id$")

;; no longer necessary?
;; (setq explicit-bash-args '("-i"))

(defun comint-last-arg () 
  "insert last arg from `comint-previous-input-string`"
  (interactive)
  (insert (car (last (split (comint-previous-input-string 0)))))
  )



;; under what circumstances is this useful?
;; (defun my-comint-mode-hook ()
;;   (setq comint-use-prompt-regexp-instead-of-fields t)
;;   (setq comint-prompt-regexp "^[0-9]+[\%] *")
;;   (setq paragraph-start comint-prompt-regexp)
;; )
;; 
;; (add-hook 'comint-mode-hook 'my-comint-mode-hook)

(add-hook 'comint-mode-hook '(lambda ()
  ;			       (debug)
			       (let ((process (get-buffer-process (current-buffer))))
				 (and process (set-process-query-on-exit-flag process nil)))
			       )
	  )
;; (pop comint-mode-hook)
(defun buffer-process-query-on-exit (&optional buffer)
  (interactive)
  (let* ((process (get-buffer-process (or buffer (current-buffer))))
	 (flag (and process (set-process-query-on-exit-flag process nil))))
    (if (interactive-p) (message "query on exit: %s" flag) flag)
    )
  )
; (buffer-process-query-on-exit)


(define-key comint-mode-map "." 'comint-last-arg)
(define-key comint-mode-map "	" 'comint-dynamic-complete-filename)
(define-key comint-mode-map "	" 'comint-dynamic-complete)

(and (boundp 'comint-mode-syntax-table) ; not bound in xemacs?
     (modify-syntax-entry ?% "." comint-mode-syntax-table))
