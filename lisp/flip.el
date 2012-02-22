(put 'flip 'rcsid 
 "$Id$")

(defvar *flip-command* (string* (eval-process "which dos2unix")))
(defvar *flop-command* (string* (eval-process "which unix2dos")))

(defun flip ()
  "convert contents of buffer from cr-lf to stream-lf format.  "
  (interactive)

  (cond
   ((null *flip-command*)
    (message "*flip-command* not found"))
   ((eq major-mode 'dired-mode)
    (eval-process (format "%s %s" *flip-command* (dired-get-filename))))
   (t
    (shell-command-on-region 
     (point-min) (point-max)
     *flip-command*))
   )
  )

(defun flop ()
  "convert contents of buffer from stream-lf to cr-lf format.  "
  (interactive)

  (cond
   ((null *flop-command)
    (message "*flop-command* not found"))
   ((eq major-mode 'dired-mode)
    (eval-process (format "%s %s" *flop-command* (dired-get-filename))))
   (t
    (shell-command-on-region 
     (point-min) (point-max)
     *flop-command*))
   )
  )


