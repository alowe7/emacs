(put 'whack-path 'rcsid
 "$Id: whack-path.el,v 1.1 2004-04-04 23:49:50 cvs Exp $")

; (getenv "PATH")
;  "/a/config/hosts/nathan/bin:/a/config/os/W32/bin:/a/bin:/bin:/usr/local/bin:/usr/local/lib/perl-5.6.1/bin/:/contrib/bin:/usr/bin:/mnt/c/WINNT/system32:/mnt/c/WINNT:/mnt/c/WINNT/System32/Wbem:/usr/local/lib/reskit/bin"

(defun whack-path ()
  (mapconcat 'identity (loop for y in (loop for x in (split (getenv "PATH") ":")
					    collect (w32-canonify x))
			     collect
			     (replace-in-string "\\\\mnt\\\\c\\\\" "c:\\" y)) ";")
  )
; (whack-path)
