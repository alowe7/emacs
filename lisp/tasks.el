(defconst rcs-id "$Id: tasks.el,v 1.1 2000-08-10 16:04:32 cvs Exp $")

; a little throw-away stack of things to do, different from todo.el
(require 'roll)

(defvar task-stack nil)

(defvar *edit-task-stack-buffer* nil)
(make-variable-buffer-local '*edit-task-stack-buffer*)

(defun push-task (task)
	(interactive "stask: ")
	(push task task-stack)
	)

(defun pop-task ()
	(interactive)
	(if (> (length task-stack) 0) (message (pop task-stack)))
	)

(defun roll-tasks ()
	(interactive)
	(if (> (length task-stack) 0)
			(roll-list task-stack nil nil nil '((?e edit-task)))
		)
	)

; (funcall (cadr (assoc (y-or-n-q-p ": " (concat "? " (vector ?e))) '((?e edit-task)))))
; (roll-dispatch (y-or-n-q-p ": " (concat "? " (vector ?e ?f))) '((?e edit-task)))
(defun writeln (&rest args)
  (insert (concat (apply 'format args) "\n")))

(defun edit-task-stack () (interactive)
  (let ((b (zap-buffer "*tasks*")))
    (map nil 'writeln  task-stack)
    (pop-to-buffer b)
    (not-modified)
    (edit-task-mode)
    )
  )


(defun edit-task-mode () 
  "the Edit Task buffer contains local tasks.
view or edit the tasks.  
press C-x C-s to save buffer contents into task-stack
press C-h b for local bindings.
"
  (setq mode-name "Task Edit")
  (add-to-list 'minor-mode-alist (list 'edit-task-mode mode-name))
  (setq *edit-task-stack-buffer* t)
  (local-set-key "" 'edit-task-stack-save)
  )

(defun edit-task-stack-save () (interactive)
  (cond ((and (boundp *edit-task-stack-buffer*)
	      *edit-task-stack-buffer*)
	 (setq task-stack
	       (catlist (buffer-string) ?
			))
	 (and (buffer-modified-p) 
	      (message "ok")
	      (not-modified)
	      )
	 )
	)
  )

(defun edit-task (&optional a i)
  (interactive)
  (if a 

      (setq a (or a (apply 'vector task-stack))
	    i (or i 0))
    (if (> (length a) i)
	(and (aset a i
		   (read-string "edit: " (aref a i)))
	     (message (aref a i)))
      )
    )
  )

(defun save-task-stack ()  (interactive)
  (and 
   (> (length task-stack) 0)
   (y-or-n-p (format "save task stack (%d elements)? " (length task-stack)))
   (loop for x in task-stack
	 do
	 (write-region (concat x "\n") nil 
		       (expand-file-name "~/todo") t 0))))

(add-hook 'kill-emacs-hook 'save-task-stack)

(defun task-help () (interactive)
  (describe-bindings "t")
  )

;;; 
(defvar task-mode-map nil)

(unless (fboundp 'ctl-C-T-prefix) 
    (define-prefix-command 'ctl-C-T-prefix))

(unless task-mode-map
  (setq task-mode-map (symbol-function 'ctl-C-T-prefix))

  (define-key task-mode-map "e" 'edit-task-stack)
  (define-key task-mode-map "h" 'task-help)
  (define-key task-mode-map "|" 'edit-task)
  ; (key-description (vector (char-ctrl ?c)))
  (define-key task-mode-map "" 'pop-task)
  (define-key task-mode-map (vector 'return) 'push-task)
  (define-key task-mode-map " " 'roll-tasks)
  )

(global-set-key "t" 'ctl-C-T-prefix)

(provide 'tasks)
