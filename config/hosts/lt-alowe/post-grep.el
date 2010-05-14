(put 'post-grep 'rcsid
 "$Id: post-grep.el,v 1.1 2010-05-14 23:13:02 alowe Exp $")
; needed to apply grep-find-command after grep loads

; (setq grep-find-command "find . -type f -print0 | xargs -0 -n -i -e ")
(grep-apply-setting 'grep-find-command  "find . -type f -print0 | xargs -0 -e grep -n -i -e ")
