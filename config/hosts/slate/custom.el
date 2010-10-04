(put 'custom 'rcsid
 "$Id$")

; random convenience functions for tombstone
(require 'perl-command)

(defvar *virtusertable* "/etc/mail/virtusertable")

(defun all-virtual-users () (interactive)
  (let ((b (zap-buffer "*virtual users*")))
    (call-process *perl-command* *virtusertable* 
		  b
		  nil
		  "-n"
		  "-e"
		  "unless (/nouser/) {split;print $_[0],'\n'}"
		  )

    (pop-to-buffer b)
    (sort-lines nil (point-min) (point-max))
    (beginning-of-buffer)
    (view-mode)
    )
  )

(defun virtusers () 
  (loop for x in  (split (eval-process *perl-command*
				       "-n"
				       "-e"
				       "unless (/nouser/) {split;print $_[0],'\n'}"
				       *virtusertable* 
				       ) "\n") collect (car (split x "@"))))
; 

(defun virtuser (name) 
  (interactive (list (completing-read "virtuser like: " (loop for x in (virtusers) collect (list x x)))))
  (let ((res (split (eval-process "grep" name *virtusertable*) "	")))
    (message (format "%s => %s" (car (split (car res) "@")) (cadr res)))
    )
  )

; (virtuser "cingular")

; no reason
(setenv "MANWIDTH" "132")

; tbd add-virtuser