(put 'window-system-init 'rcsid
 "$Id$")

(setq dired-listing-switches "-agGt")

(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

; this should be done with .Xresources
; (when (and (boundp 'default-font) (string* default-font))
;  (set-face-font 'default default-font))


(set-default 'cursor-type '(bar . 2))
(set-default 'cursor-in-non-selected-windows nil)
(setq resize-mini-windows nil)

(require 'comint-keys)
