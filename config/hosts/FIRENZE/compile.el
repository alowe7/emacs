(put 'compile 'rcsid
 "$Id$")

(chain-parent-file t)

; TBD move this crap somewhere more logical

(defvar *make-command* "make -k ")
(setq compile-command *make-command*)
(make-variable-buffer-local 'compile-command)
(set-default 'compile-command  *make-command*)


