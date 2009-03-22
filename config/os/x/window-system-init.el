(put 'window-system-init 'rcsid
 "$Id: window-system-init.el,v 1.5 2009-03-22 20:52:25 slate Exp $")

(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

; this should be done with .Xresources
; (when (and (boundp 'default-font) (string* default-font))
;  (set-face-font 'default default-font))
