;;; allow for root prompt

(setq shell-prompt-pattern "^[0-9a-zA-Z]*\\(%\\|\\$\\|#\\) *")

(setq shell-mode-syntax-table nil)

(setq shell-wrap nil)

(add-hook 'shell-mode-hook 
    '(lambda () (define-key shell-mode-map "�" '(lambda () (interactive) (insert "$_")))))

