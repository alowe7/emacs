(put 'window-system-init 'rcsid
 "$Id: window-system-init.el,v 1.4 2008-10-19 20:42:04 slate Exp $")

(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

