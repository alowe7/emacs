(add-hook 'comint-mode-hook 'my-comint-mode-hook)
(defvar comint-mode-syntax-table nil)
(defun my-comint-mode-hook () 
  (unless comint-mode-syntax-table 
    (setq comint-mode-syntax-table (copy-syntax-table)))
  (modify-syntax-entry ?_ "w" comint-mode-syntax-table)
  (set-syntax-table comint-mode-syntax-table)
; this is getting reset somewhere
  (setq comint-prompt-regexp "^[a-zA-Z0-9]+[>$%] *")
  )
