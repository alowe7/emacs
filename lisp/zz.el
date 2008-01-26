(put 'zz 'rcsid
 "$Id: zz.el,v 1.2 2008-01-26 20:13:48 slate Exp $")

; poor blind man's xz

(defun regexp-to-find (regexp)
  (if (string* regexp)
      (concat "\\( " 
	      (join 
	       (loop for x in (split regexp "|")
		     collect
		     (format "-name \"*.%s\"" x)
		     )
	       " -o ")
	      " \\)")
    "")
  )
; (regexp-to-find "a|b|c")
(defvar *default-source-regexp* "c|el|java")
(defvar *default-source-regexp-from-dir*
  '(("/z/pl/" "") ("/z/el/" "el"))
  "list of dir patterns to source regexps"
  )

(defun source-regexp-from-dir ()
  (cadr (assoc default-directory *default-source-regexp-from-dir*))
  )

(defun zz (thing &optional pat)
  "run grep-find for THING, specifying optional PAT
"
  (interactive
   (list (read-string* "grep-find (%s): " (thing-at-point 'word))
	 (and current-prefix-arg (read-string* "pat (%s): " "c|el|java"))))

  (let* (
	 (pat (or pat  (source-regexp-from-dir) *default-source-regexp* ))
	 (filenamepattern (regexp-to-find pat))
	 (cmd (format "find . -type f %s -print0 | xargs -0 -e grep -n -e %s" filenamepattern thing)))
    (debug)
    (grep-find cmd)
    )
  )

; (zz "find_auth_user_passwd")
; (define-key ctl-RET-map "\C-@" 'zz)
(require 'ctl-tick)
(define-key ctl-tick-map (vector (ctl ? )) 'zz)
