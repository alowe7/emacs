(chain-parent-file t)

; TBD move this crap somewhere more logical
(setenv "ANT_HOME"  "/usr/local/lib/apache-ant-1.6.5")
(defvar *ant-command* (substitute-in-file-name "$ANT_HOME/bin/ant "))
(defvar *make-command* "make -k ")
(setq compile-command *make-command*)
(make-variable-buffer-local 'compile-command)
(set-default 'compile-command  *make-command*)

(defun ant (&optional targets)
  (interactive "stargets: ")
  (let ((compile-command (concat *ant-command* targets)))
    (call-interactively 'compile)
    )
  )

