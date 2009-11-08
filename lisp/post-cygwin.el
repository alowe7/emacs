(put 'post-cygwin 'rcsid
 "$Id: post-cygwin.el,v 1.3 2009-11-08 22:38:08 alowe Exp $")

(require 'reg)
(defvar *cygdrive-prefix* (reg-query "machine" "software/cygnus solutions/cygwin/mounts v2" "cygdrive prefix"))
(defvar *parse-cygdrive-path* (concat "\\("  *cygdrive-prefix* "\\)\\(/\\)\\([a-z]\\)\\(/.*\\)$"))

(defun parse-cygdrive-path (path)
  (cond 
   ((string-match *parse-cygdrive-path*  path)
    (concat
  ;       (substring path (match-beginning 1) (match-end 1))
  ;       (substring path (match-beginning 2) (match-end 2))
     (substring path (match-beginning 3) (match-end 3))
     ":"
     (substring path (match-beginning 4) (match-end 4)) ))
   (t 
    path)
   )
  )

; (parse-cygdrive-path "/cygdrive/e/scratch/gorp/river song.txt")
; (parse-cygdrive-path "e:/scratch/gorp/river song.txt")
; (parse-cygdrive-path "song.txt")

(defadvice expand-file-name (before 
			     cygwin-hook-expand-file-name
			     first activate)
  ""

  (setq name "foo")
  (setq directory (or directory default-directory))
  )

; (expand-file-name "c:/usr/local/lib/emacs-22.3/.xz.dat")
; (expand-file-name ".xz.dat")

; (if (ad-is-advised 'expand-file-name) (ad-unadvise 'expand-file-name))

