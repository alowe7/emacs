(put 'comint-keys 'rcsid
 "$Id$")

(eval-when-compile (require 'cl))

(require 'ctl-ret)

(defvar *max-ret-shells* 9)
(loop for x from 0 to *max-ret-shells* do 
      (eval
       `(define-key ctl-RET-map ,(format "%d" x)
	  (lambda () (interactive) (shell2 ,x ))))
      )

(define-key ctl-RET-map (vector ?\C-7) 'lru-shell)
(define-key ctl-RET-map (vector ?\C-8) 'mru-shell)
(define-key ctl-RET-map "\C-f" 'find-indicated-file)

(require 'ctl-slash)

; grab dir from context of other window and insert it here.  if only one window showing, then current dir
(define-key ctl-/-map "0" (lambda () (interactive) (insert (save-window-excursion (other-window-1) (canonify (or (buffer-file-name) default-directory) 0)))))

(provide 'comint-keys)
