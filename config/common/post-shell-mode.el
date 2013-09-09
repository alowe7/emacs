(put 'post-shell-mode 'rcsid 
 "$Id$")
;;; allow for root prompt

(setq shell-prompt-pattern "^[0-9]+% *")
(setq shell-mode-syntax-table nil)

(setq shell-wrap nil)

(add-hook 'shell-mode-hook 
    (lambda () (define-key shell-mode-map "ß" (lambda () (interactive) (insert "$_")))))

