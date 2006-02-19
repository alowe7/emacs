(put 'locations 'rcsid
 "$Id: locations.el,v 1.3 2006-02-19 19:59:10 nathan Exp $")

(defun expand-file-name-1 (f)
  (expand-file-name (substitute-in-file-name f))
  )

(loop for x in '(
		 (all-users-profile "$ALLUSERSPROFILE")
		 (user-profile "$USERPROFILE")
		 (desktop "$USERPROFILE/Desktop")
		 (my-documents "$USERPROFILE/My Documents")
		 (my-favorites "$USERPROFILE/Favorites")
		 (my-links "$USERPROFILE/Favorites/Links")
		 (start-menu "$USERPROFILE/Start Menu")
		 (quicklaunch "$USERPROFILE/Application Data/Microsoft/Internet Explorer/Quick Launch")
		 )
      do
      (eval `(defun ,(car x)  () (interactive) (dired (expand-file-name-1 ,(cadr x))))))

(defvar etc (canonify (concat *systemroot* "/system32/drivers/etc")))

(defun hosts () (interactive)
  (find-file (concat etc "/hosts"))
  )
