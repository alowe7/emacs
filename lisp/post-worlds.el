(put 'post-worlds 'rcsid 
 "$Id: post-worlds.el,v 1.18 2005-03-01 20:13:12 cvs Exp $")

(defun push-world-p (w)
  "push current context replacing with WORLD.
a null argument means pop-world from world-stack"
  (interactive (list
		(completing-read "push world: " active-world-vector)))
  (cond ((and w (> (length w) 0)) (push-world w))
	(world-stack (pop-world))
	(t (message "world stack is empty")))
  )

(if (not (fboundp 'esc-p-prefix)) 
    (define-prefix-command 'esc-p-prefix))
(global-set-key "p" 'esc-p-prefix)
(defvar esc-p-map (symbol-function  'esc-p-prefix))
(defvar world-map (symbol-function  'esc-p-prefix))

(define-key world-map "p" 'push-world-p)
(define-key world-map "u" 'pop-world)
(define-key world-map "x" 'swap-world)
(define-key world-map "o" 'roll-world-stack)
(define-key world-map " " 'roll-world-list)
(define-key world-map "n" 'dn)
(define-key world-map "w" 'world)
(define-key world-map "f" 'wn)

;; hmmm...

(add-hook 'world-init-hook '(lambda () (global-set-key "p" 'push-world-p)))

(add-hook 'world-init-hook 
	  (function
	   (lambda () (lastworld)
	     (add-hook 'after-save-hook 'world-file-save-hook))))

(defvar *log-all-saves* nil "set to t to log all file writes")
(if *log-all-saves*
    (add-hook 'after-save-hook
	      (function
	       (lambda () 
		 (log (format "saving %s" (buffer-file-name)))))))


(global-set-key "\C-c\C-m" 'world)
(global-set-key (vector ? 'C-return) 'push-world)
(global-set-key "" 'pop-world)
(global-set-key "	" 'swap-world)
(global-set-key "" 'lastdir)
(global-set-key "" 'wn)
(global-set-key "d" 'setdn)

(setq *world-goto-lastdir* t)
(setq *shell-track-worlds* nil)

(setq *log-pre-log* t  *log-post-log* t)

; (setq world-post-change-hook nil)

(add-hook 'world-post-change-hook
	  (lambda () 
	    (lastworld t)
	    )
	  )


; (require 'fb)

(defvar *wfpat* (concat (if (eq window-system 'w32) "^(.:)*" "^")
		       "/[" (mapconcat '(lambda (x) (substring x 1)) wdirs "") "]/.*%s*"))

(defun wf (pat)
  "fastfind within `wdirs'.  see `ff'"
  (interactive "spat: ")
  (let* ((top "/")
	 (b (zap-buffer *fastfind-buffer*))
	 (pat (format *wfpat* pat)))
    (ff1 *fb-db* pat b top)

    (if (interactive-p) 
	(pop-to-buffer b)
      (split (buffer-string) "
")
      )
    )
  )

(require 'ctl-x-n)

(define-key ctl-x-3-map "f" 'wn)
(define-key ctl-x-3-map "d" '(lambda () (interactive) (dired (fw))))

(setq *world-goto-lastdir* t)
(setq *shell-track-worlds* t)
;(lastworld)

