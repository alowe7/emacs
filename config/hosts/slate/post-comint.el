; (debug nil "u r in post-comint")

(chain-parent-file t)

(unless (boundp 'comint-mode-map)
  (debug nil "again"))

(define-key comint-mode-map "\C-c\C-c" 'comint-kill-subjob)

