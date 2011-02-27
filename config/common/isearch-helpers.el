
(defun isearch-thing-at-point ()
  (interactive)
  (isearch-update-ring (thing-at-point 'symbol))
  (isearch-forward)
  )

; not sure if this isn't just masking a bug
(define-key isearch-mode-map "\C-m" 'isearch-exit)

