(put 'locations 'rcsid
 "$Id: locations.el,v 1.1 2005-06-13 20:41:03 cvs Exp $")

(defun domainname () 
  (clean-string (reg-query "machine" 
			   "system/currentcontrolset/services/tcpip/parameters" "domain"))
  )

(defvar all-users-profile
  (expand-file-name (substitute-in-file-name "$ALLUSERSPROFILE"))
  "top level dir for all user documents and settings")

(defvar user-profile
  (expand-file-name (substitute-in-file-name "$USERPROFILE"))
  "top level dir for current users documents and settings")

(defvar my-documents
  (expand-file-name (concat user-profile "/My Documents"))
  "top level dir for current users documents and settings")

(defvar my-favorites
  (expand-file-name (concat user-profile "/Favorites"))
  "top level dir for ie bookmarks")

(defvar my-links
  (expand-file-name (concat my-favorites "/Links"))
  "top level dir for ie quick links")

(defvar start-menu
  (expand-file-name (substitute-in-file-name "$USERPROFILE/Start Menu"))
  "top level dir for current users documents and settings")

(defvar quicklaunch
  (w32-canonify 
   (concat user-profile
	   "\\Application Data\\Microsoft\\Internet Explorer\\Quick Launch"
	   )))

(mapcar '(lambda (x) 
	   (eval (list 'defun x nil '(interactive) (list 'dired x))))
	'(all-users-profile user-profile my-documents my-favorites my-links start-menu quicklaunch))


(defvar etc (canonify (concat *systemroot* "/system32/drivers/etc")))

(defun hosts () (interactive)
  (find-file (concat etc "/hosts"))
  )
