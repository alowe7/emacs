(put 'mount 'rcsid 
 "$Id: mount.el,v 1.5 2001-05-05 13:12:09 cvs Exp $")
(require 'untranslate)
(require 'comint)
(provide 'mount)

(defun uncanonify (f)
  (let (
	(n (string-match ":" f))
	host fs)
    (unless (not n)
      (setq host (substring f 0 n))
      (setq fs (substring f (1+ n)))
      (format "\\\\%s%s" (upcase host) (replace-in-string "/" "\\" fs))
      )
    )
)



(defun mount (d f  &optional u p) 
  "add DRIVE as an untranslated filesystem.
  if optional FILESYSTEM is specified, net use it first
FILESYSTEM may be in the form host:/dir/dir...
if DRIVE is '*' then use the first available drive 
return letter drive name.
if optional USER is given, logon as that user
"
  (interactive "sDrive: \nsFilesystem: ")
  (let* ((u (or u (getenv "USERNAME")))
	 (n (read-string (format "login for %s (%s): " f u) u))
	 (p (comint-read-noecho (format "password: " f n) t))
	 (d (if (string* f)
		(unless (call-process 
			 "net"
			 nil
			 (zap-buffer "zap")
			 t
			 "use"
			 (or (string* d) "*")
			 (uncanonify f)
			 p
			 (format "/user:%s" n)
			 )
		  (message "net use failed")
		  (set-buffer "zap")
		  (beginning-of-buffer)
		  (forward-word 2)
		  (indicated-word ":")))))
    (add-untranslated-filesystem d)
    d)
  )

; (mount "f:" "freefall:/projects")
; (add-untranslated-filesystem "f:")
; (describe-variable 'untranslated-filesystem-list)