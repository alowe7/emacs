(put 'post-xz-loads 'rcsid "$Id: post-xz-loads.el,v 1.3 2000-10-03 16:44:07 cvs Exp $")
(define-key xz-map "" 
  '(lambda (string) (interactive (list (complete-indicated-word "goto function definition (%s): " obarray)))
     (xz-query-format (concat "./fd" (or (and (> (length string) 0) string)  (indicated-word))))))


(define-key xz-map "" 
  '(lambda (string) (interactive (list (complete-indicated-word "goto variable declaration (%s): " obarray)))
 
     (xz-query-format (concat "./id" (or (and (> (length string) 0) string)  (indicated-word))))))


(define-key xz-map "m" 
  '(lambda (string) (interactive (list (read-string (format "goto module (%s): " (indicated-word)))))
     (xz-query-format (concat "./md" (or (and (> (length string) 0) string)  (indicated-word))))))




