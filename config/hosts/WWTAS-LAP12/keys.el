(put 'keys 'rcsid
 "$Id: keys.el 1068 2012-08-15 17:33:58Z alowe $")

(chain-parent-file t)

(autoload 'logview-hours "logview-mode")
(global-set-key [f10] 'logview-hours)

(require 'ctl-ret)
(define-key ctl-RET-map (vector (ctl ? )) 'grep-find)
(define-key ctl-RET-map "
" 'select-locate-buffer)


(define-key ctl-RET-map "\C-l" 'flush-lines)
(define-key ctl-RET-map "\C-k" 'keep-lines)
(define-key ctl-RET-map "\C-s" 'isearch-thing-at-point)

(require 'ctl-slash)
(define-key ctl-/-map "u" 'makeunbound)
(define-key ctl-/-map "\C-d" 'sisdir)


; (kbd "C-S-a") = (quote [33554433])
(global-set-key (kbd "C-S-a") (quote soft-fill-paragraph))

(global-set-key (kbd "C-x C-.") 'point-to-register)
(global-set-key (kbd "C-x C-,") 'jump-to-register)

(require 'ctl-dot)
(define-key ctl-.-map "\C-f" 'find-parent-file)

; make f1 available for binding
(if (eq (key-binding (vector 'f1)) 'help-command)
    (global-set-key (vector 'f1) nil))

; not sure if this isn't just masking a bug
(define-key isearch-mode-map "\C-m" 'isearch-exit)


(define-key ctl-RET-map  "\C-r" 'rcsid)
(define-key ctl-RET-map  "\C-m" 'byte-compile-file)

(define-key ctl-RET-map  "b" 'list-bookmarks)

(define-key ctl-x-map (vector 'up) 'increment-screen-height)
(define-key ctl-x-map (vector 'right) 'increment-screen-width)
(define-key ctl-x-map (vector 'down) (function (lambda (x) (interactive "p") (increment-screen-height (- x)))))
(define-key ctl-x-map (vector 'left) (function (lambda (x) (interactive "p") (increment-screen-width (- x)))))
