(put 'post-xz-loads 'rcsid 
 "$Id: post-xz-loads.el,v 1.8 2001-09-08 20:50:36 cvs Exp $")

(define-key xz-map "" 
  '(lambda (string) (interactive (list (complete-indicated-word "goto function definition (%s): " obarray)))
     (xz-query-format (concat "./fd" (or (and (> (length string) 0) string)  (indicated-word))))))


(define-key xz-map "" 
  '(lambda (string) (interactive (list (complete-indicated-word "goto variable declaration (%s): " obarray)))
 
     (xz-query-format (concat "./id" (or (and (> (length string) 0) string)  (indicated-word))))))


(define-key xz-map "m" 
  '(lambda (string) (interactive (list (read-string (format "goto module (%s): " (indicated-word)))))
     (xz-query-format (concat "./md" (or (and (> (length string) 0) string)  (indicated-word))))))

(add-hook 'xz-load-hook '(lambda () 
			   (load-library "xz-helpers.el")
			   (define-key xz-mode-map "f" 'xz-goto-hits)))


