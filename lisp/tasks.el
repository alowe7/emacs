(put 'tasks 'rcsid "$Id: tasks.el,v 1.4 2000-10-03 16:44:08 cvs Exp $")

; a little throw-away stack of things to do, different from todo.el
(require 'roll)

(defvar task-stack nil)

(defvar *edit-task-stack-buffer* nil)
(defvar task-stack-clean t)

(make-variable-buffer-local '*edit-task-stack-buffer*)

(defun push-task (task)
	(interactive "stask: ")
	(push task task-stack)
	(setq task-stack-clean nil)
	)

(defun pop-task ()
	(interactive)
	(if (> (length task-stack) 0) (message (pop task-stack)))
	(setq task-stack-clean nil)
	)

(defun delete-task (&optional l b)
  (interactive)
  (delete* b task-stack)
  (setq task-stack-clean nil)
  )

(defun roll-tasks ()
	(interactive)
	(if (> (length task-stack) 0)
			(roll-list task-stack nil 'delete-task nil 
				   '((?e edit-task)))
		)
	)

; (funcall (cadr (assoc (y-or-n-q-p ": " (concat "? " (vector ?e))) '((?e edit-task)))))
; (roll-dispatch (y-or-n-q-p ": " (concat "? " (vector ?e ?f))) '((?e edit-task)))
(defun writeln (&rest args)
  (insert (concat (apply 'format args) "\n")))

(defun edit-task-stack () (interactive)
  (let ((b (or *edit-task-stack-buffer*
	       (setq *edit-task-stack-buffer*
		     (zap-buffer "*tasks*")))))
    (map nil 'writeln  task-stack)
    (pop-to-buffer b)
    (not-modified)
    (edit-task-mode)
    )
  )


(defvar edit-task-mode nil)

(defun edit-task-mode () 
  "the Edit Task buffer contains local tasks.
view or edit the tasks.  
press C-x C-s to save buffer contents into task-stack
press C-h b for local bindings.
"
  (setq mode-name "Task Edit")
  (add-to-list 'minor-mode-alist (list 'edit-task-mode mode-name))
  (setq *edit-task-stack-buffer* t)
  (local-set-key "" 'edit-task-stack-save)
  (local-set-key "" 'save-task-stack)
  (message "type  to save and remember task stack,  to write ~/.tasks") 
  )

(defun edit-task-stack-save () (interactive)
  (cond ((and (boundp *edit-task-stack-buffer*)
	      *edit-task-stack-buffer*)
	 (if (buffer-modified-p) 
	     (progn
	       (setq task-stack-clean nil)
	       (setq task-stack
		     (split (buffer-string) ?
			    ))

	       )
	   )
	 (bury-buffer))))

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

(defun init-task-stack ()  (interactive)
  (let ((f (expand-file-name "~/.tasks")))
    (and 
     (file-exists-p f)
     (setq task-stack (split (read-file f) "\n")))
    )
  )

(defun save-task-stack ()  (interactive)
  (and 
   (> (length task-stack) 0)
   (y-or-n-p (format "save task stack (%d elements)? " (length task-stack)))
   (loop for x in task-stack
	 do
	 (write-region (concat x "\n") nil 
		       (expand-file-name "~/.tasks") t 0))))

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
  (define-key task-mode-map "d" '(lambda () (call-interactively 'debug)))
  (define-key task-mode-map (vector 'return) 'push-task)
  (define-key task-mode-map " " 'roll-tasks)
  )

(global-set-key "t" 'ctl-C-T-prefix)

(defun bootstrap-task ()
  (interactive)
  ; placeholder for autoload
  (init-task-stack)
  (message "tasks loaded.  press \"^Cth\" for help")
  )

(provide 'tasks)
