(put 'host-init 'rcsid
 "$Id: host-init.el,v 1.3 2004-01-23 17:17:46 cvs Exp $")

(defvar process-environment-list (loop for x in  process-environment collect (split x "=")))

; (assoc "PATH"  process-environment-list)

(defun setenv* (var val)
  "fancy version of setenv that clobbers process-environment as well"
  (interactive "svar: \nsval: ")
  (setenv var val)
  (setq process-environment-list
	(remove-if '(lambda (x) (string= (car x) var )) process-environment-list))
  (nconc process-environment-list
	 (list (list var val)))
  (setq process-environment
	(loop for x in process-environment-list collect 
	      (concat (car x) "=" (cadr x))))
  )

(setenv* "PATH" "/u00/oracle/product/8.1.7/bin:/net/monolith/homes/alowe/bin:/usr/local/ActivePerl-5.6/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:sbin:/usr/openwin/bin")

(setq comint-prompt-regexp "^[0-9]+[>$%] *")

; somethings still wrong with the path.  meanwhile:
(setq locate-command "/usr/local/bin/locate")

(global-set-key "~" 'diff-backup)

(require 'eval-process)

(modify-frame-parameters (selected-frame) (list (cons 'title (format "%s@%s" (eval-process "whoami") (eval-process "uname" "-n")))))
