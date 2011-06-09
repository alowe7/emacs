(put 'grep 'rcsid
 "$Id$")

(chain-parent-file t)

; did the default for this change in emacs 23?
(grep-apply-setting  'grep-find-command "find .  -path *.svn* -o ! -type f -o -print0 | xargs -0 -e grep -n -i -e ")
