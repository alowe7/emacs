(put 'post-xz-loads 'rcsid 
 "$Id: post-xz-loads.el,v 1.10 2001-11-20 00:37:45 cvs Exp $")

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
			   (define-key xz-mode-map "f" 'xz-goto-hits)
			   (define-key xz-mode-map "p" 'previous-xz-search)
			   (define-key xz-mode-map "n" 'next-xz-search)

			   (global-set-key "\M-p" 'xz-previous-hit)
			   (global-set-key "\M-n" 'xz-next-hit)

			   ))
