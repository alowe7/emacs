(put 'post-worlds 'rcsid 
 "$Id: post-worlds.el,v 1.9 2003-04-02 21:34:53 cvs Exp $")


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
(let ((map (symbol-function  'esc-p-prefix)))
  (define-key map "p" 'push-world-p)
  (define-key map "u" 'pop-world)
  (define-key map "x" 'swap-world)
  (define-key map "o" 'roll-world-stack)
  (define-key map " " 'roll-world-list)
  map)

;; hmmm...

(add-hook 'world-init-hook '(lambda () (global-set-key "p" 'push-world-p)))

(add-hook 'world-init-hook 
	  (function
	   (lambda () (lastworld)
	     (add-hook 'after-save-hook 'world-file-save-hook))))

(add-hook 'after-save-hook
	  (function
	   (lambda () 
	     (log (format "saving %s" (buffer-file-name))))))

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

(add-hook 'world-post-change-hook
	  (lambda () 
	    (write-region 
	     (concat "cd " (w32-canonify (expand-file-name (fw)))) nil (expand-file-name "/w.cmd"))))
