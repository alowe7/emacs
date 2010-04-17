(put 'grep 'rcsid
 "$Id: grep.el,v 1.1 2010-04-17 18:53:08 alowe Exp $")

(chain-parent-file t)

; did the default for this change in emacs 23?
(grep-apply-setting  'grep-find-command "find . -type f -print0 | xargs -0 -e grep -n -i -e ")
