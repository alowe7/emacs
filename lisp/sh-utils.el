(put 'sh-utils 'rcsid 
 "$Id: sh-utils.el,v 1.3 2000-10-03 16:50:29 cvs Exp $")

;; sh and c workalikes

(defun pwd ()
  (interactive)
  (message default-directory))

(defun pwd-other-window ()
  (interactive)
  (save-excursion
    (other-window 1) 
    (message default-directory)
    (other-window -1) )
  )


(defun cd-other-window ()
  " change the current window's current directory to that of other window"
  (interactive)
  (save-excursion
    (other-window 1)
    (let ((z (pwd)))
      (other-window -1)
      (cd z))))


(defun touch (fn)
  "touch filename"
  (call-process "touch" nil 0 nil fn)
  t
  )


(defun chmod (mode)
  "change mode on file associated with current buffer"
  (interactive "smode: ")
  (call-process "chmod" nil 0 nil mode (buffer-file-name)))

;; these may be obsolete


(defun getenvp (which) 
  (interactive "sWhich: ")
  "like getenv, but returns nil if not set" 
  (let ((v (getenv which)))
    (and (> (length v) 0) v)
    )
  )


(defun strrspn (s p)
  (loop
   for x downfrom (length s) to 1
   if (not (in (elt s (1- x)) p)) return (substring s 0 x)
   finally return ""
   )
  )

; these do the same thing, except in returns the position like strchr
(defun in (c s) (string-match (format "%c" c) s))
