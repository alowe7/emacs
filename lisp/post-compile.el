(put 'post-compile 'rcsid 
 "$Id: post-compile.el,v 1.4 2000-10-03 16:50:28 cvs Exp $")

; (read-string "loading post-compile")

(defun compile1 (command error-message &optional name-of-mode)
  (save-some-buffers)
  (if compilation-process
      (if (or (not (eq (process-status compilation-process) 'run))
	(yes-or-no-p "A compilation process is running; kill it? "))
    (condition-case ()
	(let ((comp-proc compilation-process))
    (interrupt-process comp-proc)
    (sit-for 1)
    (delete-process comp-proc))
      (error nil))
  (error "Cannot have two compilation processes")))
  (setq compilation-process nil)
  (compilation-forget-errors)
  (setq compilation-error-list t)
  (setq compilation-error-message error-message)
  (with-output-to-temp-buffer "*compilation*"
    (princ "cd ")
    (princ default-directory)
    (terpri)
    (princ command)
    (terpri))
  (setq compilation-process
	(start-process "compilation" "*compilation*" (split command)))
  (set-process-sentinel compilation-process 'compilation-sentinel)
  (let* ((thisdir default-directory)
   (outbuf (process-buffer compilation-process))
   (outwin (get-buffer-window outbuf))
   (regexp compilation-error-regexp))
    (if (eq outbuf (current-buffer))
  (goto-char (point-max)))
    (save-excursion
      (set-buffer outbuf)
      (buffer-flush-undo outbuf)
      (let ((start (save-excursion (set-buffer outbuf) (point-min))))
  (set-window-start outwin start)
  (or (eq outwin (selected-window))
      (set-window-point outwin start)))
      (setq default-directory thisdir)
      (fundamental-mode)
      (make-local-variable 'compilation-error-regexp)
      (setq compilation-error-regexp regexp)
      (setq mode-name (or name-of-mode "Compilation"))
      ;; Make log buffer's mode line show process state
      (setq mode-line-process '(": %s"))
      t)))
; 
(defvar compilation-old-error-list nil
  "Value of `compilation-error-list' after errors were parsed.")
