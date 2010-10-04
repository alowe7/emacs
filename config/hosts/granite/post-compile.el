(put 'post-compile 'rcsid
 "$Id$")

(chain-parent-file t)

; (setenv "PATH" (concat (getenv "PATH") ";c:\\usr\\local\\lib\\tw-3.01\\bin"))

(setenv "JAVA_HOME" "c:/Program Files/Java/jre1.6.0_03")

(setenv "ANT_HOME"  "/usr/local/lib/apache-ant-1.6.5")
(defvar *ant-command* (substitute-in-file-name "$ANT_HOME/bin/ant "))
(defvar *make-command* "make -k ")
(setq compile-command *ant-command*)
(make-variable-buffer-local 'compile-command)
(set-default 'compile-command  *ant-command*)
