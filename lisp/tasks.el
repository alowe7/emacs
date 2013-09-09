(put 'tasks 'rcsid 
 "$Id$")

; a little throw-away stack of things to do, different from todo.el
(require 'roll)

(defvar task-stack nil)

(defvar *edit-task-stack-buffer* nil)
(defvar task-stack-clean t "set if task stack does not require saving")

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
    (goto-char (point-min))
    (set-buffer-modified-p nil)
    (edit-task-mode)
    )
  )

(defun view-task-stack () (interactive)
  (let ((b (or *edit-task-stack-buffer*
	       (setq *edit-task-stack-buffer*
		     (zap-buffer "*tasks*")))))
    (map nil 'writeln  task-stack)
    (pop-to-buffer b)
    (set-buffer-modified-p nil)
    (goto-char (point-min))
    (setq buffer-read-only t)
    (view-mode)
    (local-set-key "" (function (lambda () (interactive) (setq buffer-read-only t) (call-interactively 'edit-task-stack))))
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
  (local-set-key "" 'view-task-stack)
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
  (describe-bindings "k")
  )

;;; 
(defvar task-mode-map nil)

(unless (fboundp 'ctl-C-K-prefix) 
    (define-prefix-command 'ctl-C-K-prefix))

(unless task-mode-map
  (setq task-mode-map (symbol-function 'ctl-C-K-prefix))

  (define-key task-mode-map "e" 'edit-task-stack)
  (define-key task-mode-map "v" 'view-task-stack)
  (define-key task-mode-map "h" 'task-help)
  (define-key task-mode-map "|" 'edit-task)
  ; (key-description (vector (char-ctrl ?c)))
  (define-key task-mode-map "" 'pop-task)
;  (define-key task-mode-map "d" 'delete-task)
;  (define-key task-mode-map "m" 'mark-task) ; as done, pending, etc.
  (define-key task-mode-map (vector 'return) 'push-task)
  (define-key task-mode-map " " 'roll-tasks)
  )

(defun bootstrap-task ()
  (interactive)
  ; placeholder for autoload
  (global-set-key "k" 'ctl-C-K-prefix)

  (init-task-stack)
  (message "tasks loaded.  press \"^C-k h\" for help")
  )

; put this in your .emacs
; (autoload 'bootstrap-task "tasks.el")
; (global-set-key "k" 'bootstrap-task)

(provide 'tasks)
