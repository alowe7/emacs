(put 'locations 'rcsid
 "$Id: locations.el,v 1.5 2006-03-03 20:24:26 alowe Exp $")

(defun expand-file-name-1 (f)
  (expand-file-name (substitute-in-file-name f))
  )

(loop for x in `(
		 (all-users-profile "$ALLUSERSPROFILE")
		 (user-profile "$USERPROFILE")
		 (desktop "$USERPROFILE/Desktop")
		 (my-documents
		  ,(if (file-directory-p "/documents")  "/documents" "$USERPROFILE/My Documents"))
		 (my-favorites "$USERPROFILE/Favorites")
		 (my-links "$USERPROFILE/Favorites/Links")
		 (start-menu "$USERPROFILE/Start Menu")
		 (quicklaunch "$USERPROFILE/Application Data/Microsoft/Internet Explorer/Quick Launch")
		 )
      do
      (eval `(defun ,(car x)  () (interactive) (dired (expand-file-name-1 ,(cadr x)))))
      (eval `(defvar ,(car x)  ,(canonify (cadr x))))
      )

(defvar etc (canonify (concat *systemroot* "/system32/drivers/etc")))

(defun hosts () (interactive)
  (find-file (concat etc "/hosts"))
  )

(provide 'locations)
