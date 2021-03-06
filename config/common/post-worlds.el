(put 'post-worlds 'rcsid 
 "$Id$")

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

(define-key world-map " " 'roll-world-list)
; xxx todo use bookmarks for this...
; (define-key world-map "n" 'dn)

(define-key world-map "w" 'world)
(define-key world-map "f" 'wn)

;; hmmm...

(add-hook 'world-init-hook (lambda () (global-set-key "p" 'push-world-p)))

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

(defvar *wfpat* (concat "^"
		       "/[" (mapconcat 'identity (wdirs) "") "]/[^%s].*%s*"
		       )
	      )

(defun wf (pat)
  "fastfind within `wdirs'.  see `ff'"
  (interactive "spat: ")
  (let* ((top "/")
	 (b (zap-buffer *fastfind-buffer*))
	 (pat (format *wfpat* 
		      (substring pat 0 1) pat)))

    (ff1 *fb-db* pat b top)

    (if (called-interactively-p 'any)
	(pop-to-buffer b)
      (split (buffer-string) ?\C-j)
      )
    )
  )

(require 'ctl-x-n)

(define-key ctl-x-3-map "f" 'wn)
(define-key ctl-x-3-map "d" (lambda () (interactive) (dired (fw))))

(setq *world-goto-lastdir* t)
(setq *shell-track-worlds* t)
;(lastworld)

