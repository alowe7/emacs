(put 'post-shell-mode 'rcsid 
 "$Id: post-shell-mode.el,v 1.5 2002-04-09 03:32:00 cvs Exp $")
;;; allow for root prompt

(setq shell-prompt-pattern "^[0-9]+% *")
(setq shell-mode-syntax-table nil)

(setq shell-wrap nil)

(add-hook 'shell-mode-hook 
    '(lambda () (define-key shell-mode-map "ß" '(lambda () (interactive) (insert "$_")))))

