(put 'shell2 'rcsid 
 "$Id: shell2.el,v 1.11 2005-02-02 22:35:00 cvs Exp $")
(require 'comint)
(require 'shell)
(defvar shell-popper 'switch-to-buffer) ; could also use pop-to-buffer

(defun shell2 (&optional shell-num &optional other-frame specific-shell-file-name mode)
  "Run an inferior shell, with I/O through buffer *shell*.
If buffer exists but shell process is not running, make new shell.
If buffer exists and shell process is running, just switch to buffer `*shell*'.
unless SPECIFIC-SHELL-FILE-NAME is specified, program used comes from variable `explicit-shell-file-name',
 or (if that is nil) from the ESHELL environment variable,
 or else from SHELL if there is no ESHELL.
If a file `~/.emacs_SHELLNAME' exists, it is given as initial input
 (Note that this may lose due to a timing error if the shell
  discards input when it starts up.)
unless optional MODE is specified, the buffer is put in Shell mode, giving commands for sending input
and controlling the subjobs of the shell.  See `shell-mode'.
See also the variable `shell-prompt-pattern'.

The shell file name (sans directories) is used to make a symbol name
such as `explicit-csh-args'.  If that symbol is a variable,
its value is used as a list of arguments when invoking the shell.
Otherwise, one argument `-i' is passed to the shell.

\(Type \\[describe-mode] in the shell buffer for a list of commands.)"
  (interactive)

  (let* ((shell-name 
	  (concat "shell" (and shell-num (format "-%s" shell-num))))
	 (shell-buffer-name (concat "*" shell-name "*")))
    (or (comint-check-proc shell-buffer-name)
	(let* ((prog (or specific-shell-file-name
			 explicit-shell-file-name
			 (getenv "ESHELL")
			 (getenv "SHELL")
			 "/bin/sh"))		     
	       (name (file-name-nondirectory prog))
	       (startfile (concat "~/.emacs_" name))
	       (xargs-name (intern-soft (concat "explicit-" name "-args")))
	       shell-buffer)
	  (save-excursion
	    (set-buffer (apply 'make-comint shell-name prog
			       (if (file-exists-p startfile) startfile)
			       (if (and xargs-name (boundp xargs-name))
				   (symbol-value xargs-name)
				 '("-i"))))
	    (setq shell-buffer (current-buffer))

	    (if mode (funcall mode)
	      (shell-mode))

	    ;; this is now buffer-local
	    (setq explicit-shell-file-name prog)
	    )))
    (if other-frame 
	(switch-to-buffer-other-frame shell-buffer-name)
      (funcall shell-popper shell-buffer-name))

    ;; return the buffer
    (get-buffer shell-buffer-name)
    )
  )

(provide 'shell2)
