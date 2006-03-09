; features required but not used by w3m

(provide (quote pccl))
(provide (quote pcustom))
(provide (quote poem))
(provide (quote poe))
(fset 'custom-set-face-bold 'identity)
(fset 'custom-face-bold 'identity)

(defun code-detect-region (start end)
)

(defun get-base-code (coding-system)
)

(provide 'w3m-compat)
