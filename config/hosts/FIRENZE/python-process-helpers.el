(put 'python-process-helpers 'rcsid
 "$Id$")

(require 'eval-process)

(defvar *python-command* "/Python27/python")
(defun eval-python-process (script args)
  (eval-process (format "%s %s %s" *python-command* script args))
  )

(defun* pipe-string-to-process (stuff command &rest args)
  "send STUFF via stdin to COMMAND with optional args
returns output from command, if any
"

  (let* (
	 (b (zap-buffer (concat command "-pipe-buffer")))
	 (p (apply 'start-process (nconc (list (concat command "-pipe-process") b command) args)))
	 )

    (unless (and (processp p) (eq (process-status p) 'run)) (error "process %s died" command))
    (process-send-string p stuff)
    (process-send-eof p)
    (accept-process-output p)
    (loop for i from 1 to 1000 unless (eq (process-status p) 'exit) do (sit-for 0.1))
    (if (and (processp p) (eq (process-status p) 'run)) (error "process %s did not die" command))

    (unless (= (process-exit-status p) 0) 
      (error  "process %s died with exit code %d.  %s" command (process-exit-status p)     
	      (with-current-buffer b (buffer-string))))

    (with-current-buffer b (chomp (buffer-string)))
    )
  )

(defun keyword-args-to-switches (argmap)
  "ARGMAP is a  is an alist of the form: ((--switchname value) ...)
this function returns a string suitable for  appending to a command line.
switch is ommitted where value is nil

for example:
	(let ((foo 1) (bar ''baz'') bo) (keyword-args-to-switches `((--foo ,foo) (--bar ,bar) (--bo ,bo)))))
returns:
	--foo 1 --bar baz 
"

  (mapconcat 
   #'(lambda (x) (and (cadr x) (format (if (and (stringp (cadr x)) (string-match " " (cadr x))) "%s '%s'" "%s %s") (car x) (cadr x))))
   argmap " ")
  )
; (let ((foo 1) (bar "baz") bo) (keyword-args-to-switches `((--foo ,foo) (--bar ,bar) (--bo ,bo))))


(provide 'python-process-helpers)
