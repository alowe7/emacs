(defconst rcs-id "$Id: post-shell-mode.el,v 1.2 2000-07-30 21:07:47 andy Exp $")
;;; allow for root prompt

(setq shell-prompt-pattern "^[0-9a-zA-Z]*\\(%\\|\\$\\|#\\) *")

(setq shell-mode-syntax-table nil)

(setq shell-wrap nil)

(add-hook 'shell-mode-hook 
    '(lambda () (define-key shell-mode-map "ß" '(lambda () (interactive) (insert "$_")))))

