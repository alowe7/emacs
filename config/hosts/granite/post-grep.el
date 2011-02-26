(put 'post-grep 'rcsid
 "$Id: post-grep.el 930 2011-01-02 21:01:45Z alowe $")
; needed to apply grep-find-command after grep loads

(setq grep-command "grep -nH -i -e ")

; let default grep-find-command exclude .svn repos
(grep-apply-setting 'grep-find-command
   "find . -type f \\( -path \"*.svn*\" -o -print0 \\) | xargs -0 -e grep -n -i -e ")

; (grep-apply-setting 'grep-find-command  "find . -type f -print0 | xargs -0 -e grep -n -i -e ")
