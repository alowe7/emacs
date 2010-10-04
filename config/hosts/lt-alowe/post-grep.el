(put 'post-grep 'rcsid
 "$Id$")
; needed to apply grep-find-command after grep loads

; (setq grep-find-command "find . -type f -print0 | xargs -0 -n -i -e ")
(grep-apply-setting 'grep-find-command  "find . -type f -print0 | xargs -0 -e grep -n -i -e ")
