(put 'window-system-init 'rcsid
 "$Id$")

(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

; this should be done with .Xresources
; (when (and (boundp 'default-font) (string* default-font))
;  (set-face-font 'default default-font))
