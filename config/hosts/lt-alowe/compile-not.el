(defvar *ant-command* "/usr/local/lib/apache-ant-1.6.5/bin/ant ")
(defvar *make-command* "make -k ")
(setq compile-command *ant-command*)
(make-variable-buffer-local 'compile-command)
(set-default 'compile-command  *ant-command*)

; advice won't work to tweak an interactive form, or an autoload
(require 'compile)
(unless (and (boundp 'orig-compile) (not (and (listp orig-compile) (eq (car orig-compile 'autoload)))) orig-compile)
  (setq orig-compile (symbol-function 'compile)))

(defun compile (command)
  "hook compile to call make if default-directory contains a makefile, ant otherwise"
  (interactive
   (let ((compile-command
	  (or (and (file-exists-p "Makefile") *make-command*) compile-command)))
     (if (or compilation-read-command current-prefix-arg)
	 (list (read-from-minibuffer "Compile command: "
				     (eval compile-command) nil nil
				     '(compile-history . 1)))
       (list (eval compile-command)))))

  (set-default 'compile-command  compile-command)

  (funcall orig-compile command)
  )
