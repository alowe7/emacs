(put 'grep 'rcsid
 "$Id: grep.el 1018 2011-06-09 17:07:34Z alowe $")

(chain-parent-file t)

; did the default for this change in emacs 23?
(grep-apply-setting  'grep-find-command "find .  -path *.svn* -o ! -type f -o -print0 | xargs -0 -e grep -n -i -e ")
