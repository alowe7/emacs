(put 'post-shell-mode 'rcsid 
 "$Id: post-shell-mode.el,v 1.4 2000-10-03 16:50:28 cvs Exp $")
;;; allow for root prompt

(setq shell-prompt-pattern "^[0-9a-zA-Z]*\\(%\\|\\$\\|#\\) *")

(setq shell-mode-syntax-table nil)

(setq shell-wrap nil)

(add-hook 'shell-mode-hook 
    '(lambda () (define-key shell-mode-map "ß" '(lambda () (interactive) (insert "$_")))))

