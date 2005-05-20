(put 'os-init 'rcsid
 "$Id: window-system-init.el,v 1.1 2005-05-20 20:27:57 cvs Exp $")

(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
