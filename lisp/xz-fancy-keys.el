(put 'xz-fancy-keys 'rcsid
 "$Id: xz-fancy-keys.el,v 1.1 2004-03-27 19:03:09 cvs Exp $")

;; define some fancy key maps

(require 'keys)

(if (not (fboundp 'ctl-esc-prefix))
    (define-prefix-command 'ctl-esc-prefix)) ;; don't wipe out map if it already exists
(setq ctl-esc-map (symbol-function  'ctl-esc-prefix))
(define-key  xz-map "" 'ctl-esc-prefix) 

(define-key ctl-esc-map "" 'xz-compound-query)
(define-key ctl-esc-map (vector (ctl ?-)) 'set-proximity-limit) ; C-\ ESC C--
(define-key ctl-esc-map "" 'xz-constrained-compound-query)

(define-key ctl-esc-map (vector (ctl ?8))
  '(lambda (arg) (interactive "P") 
     (message (if (string= "1" (substring (xq ".*?") 0 1)) "enabled" "disabled"))))

(define-key ctl-esc-map (vector (ctl ? )) 'xz-constrained-query-format)


