(put 'CYGWIN_NT-4.0 'rcsid 
 "$Id: os-init.el,v 1.1 2000-10-30 19:08:04 cvs Exp $")

;; config file for gnuwin-1.0

(setq binary-process-input t
			explicit-shell-file-name "bash"
			shell-command-switch "-c"
			)

; this treats all files on z:\\foo as binary
;(add-untranslated-filesystem "Z:")

;this undoes that
; remove-untranslated-filesystem

(autoload 'shell2 "shell2" t)
