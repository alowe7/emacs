(put 'locations 'rcsid
 "$Id: locations.el,v 1.7 2007-01-12 00:45:18 noah Exp $")

(defun substitute-expand-file-name (f)
  (expand-file-name (substitute-in-file-name f))
  )

(require 'regtool)
(require 'typesafe)

(loop for x in `(
		 (all-users-profile "$ALLUSERSPROFILE")
		 (user-profile "$USERPROFILE")
		 (desktop "$USERPROFILE/Desktop")
		 (my-documents
		  ,(or
		    (string*
		     (regtool "get" "/user/Software/Microsoft/Windows/CurrentVersion/Explorer/User Shell Folders/Personal"))
		    "$USERPROFILE/My Documents")
		  )
		  (my-favorites "$USERPROFILE/Favorites")
		  (my-links "$USERPROFILE/Favorites/Links")
		  (start-menu "$USERPROFILE/Start Menu")
		  (quicklaunch "$USERPROFILE/Application Data/Microsoft/Internet Explorer/Quick Launch")
		  )
      do
      (eval `(defun ,(car x)  () (interactive) (dired (substitute-expand-file-name ,(cadr x)))))
      (eval `(defvar ,(car x)  ,(canonify (cadr x))))
      )

(defvar etc (canonify (concat *systemroot* "/system32/drivers/etc")))

(defun hosts () (interactive)
  (find-file (concat etc "/hosts"))
  )

(provide 'locations)
