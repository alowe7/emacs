(put 'post-comint 'rcsid 
 "$Id: post-comint.el,v 1.7 2001-01-17 19:12:37 cvs Exp $")

(setq comint-prompt-regexp "^[0-9a-zA-Z]*% *")

(setq explicit-bash-args '("-login" "-i"))


(defun comint-last-arg () 
  "insert last arg from `comint-previous-input-string`"
  (interactive)
  (insert (car (last (split (comint-previous-input-string 0)))))
  )

(define-key comint-mode-map "." 'comint-last-arg)

