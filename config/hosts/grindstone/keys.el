(put 'keys 'rcsid
 "$Id: keys.el 1017 2011-06-06 04:32:11Z alowe $")

(chain-parent-file t)

(autoload 'logview-hours "logview-mode")
(global-set-key [f10] 'logview-hours)

(require 'ctl-ret)
(define-key ctl-RET-map (vector (ctl ? )) 'grep-find)

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)

(define-key ctl-RET-map "
" 'select-locate-buffer)

(require 'ctl-slash)
(define-key ctl-/-map "u" 'unbind)

; (kbd "C-S-a") = (quote [33554433])
(global-set-key (kbd "C-S-a") (quote soft-fill-paragraph))

(global-set-key (kbd "C-x C-.") 'point-to-register)
(global-set-key (kbd "C-x C-,") 'jump-to-register)

(require 'ctl-dot)
(define-key ctl-.-map "\C-f" 'find-parent-file)

; make f1 available for binding
(if (eq (key-binding (vector 'f1)) 'help-command)
    (global-set-key (vector 'f1) nil))
